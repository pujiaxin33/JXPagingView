//
//  JXPagerSmoothView.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/15.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "JXPagerSmoothView.h"

static NSString *JXPagerSmoothViewCollectionViewCellIdentifier = @"cell";

@interface JXPagerSmoothCollectionView : UICollectionView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *pagerHeaderContainerView;
@end
@implementation JXPagerSmoothCollectionView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self.pagerHeaderContainerView];
    if (CGRectContainsPoint(self.pagerHeaderContainerView.bounds, point)) {
        return NO;
    }
    return YES;
}
@end

@interface JXPagerSmoothView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<JXPagerSmoothViewDataSource> dataSource;
@property (nonatomic, strong) JXPagerSmoothCollectionView *listCollectionView;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, id<JXPagerSmoothViewListViewDelegate>> *listDict;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIView*> *listHeaderDict;
@property (nonatomic, assign, getter=isSyncListContentOffsetEnabled) BOOL syncListContentOffsetEnabled;
@property (nonatomic, strong) UIView *pagerHeaderContainerView;
@property (nonatomic, assign) CGFloat currentPagerHeaderContainerViewY;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIScrollView *currentListScrollView;
/// 顶部 Header 是否跟随列表弹性效果。主要用来配置列表下拉刷新效果。
@property (nonatomic, assign) BOOL pagerHeaderBounces;
@property (nonatomic, assign) CGFloat heightForPagerHeader;
@property (nonatomic, assign) CGFloat heightForPinHeader;
@property (nonatomic, assign) CGFloat heightForPagerHeaderContainerView;
@property (nonatomic, assign) CGFloat currentListInitializeContentOffsetY;
@property (nonatomic, strong) UIScrollView *singleScrollView;
@end

@implementation JXPagerSmoothView

- (void)dealloc
{
    for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
        [[list listScrollView] removeObserver:self forKeyPath:@"contentOffset"];
        [[list listScrollView] removeObserver:self forKeyPath:@"contentSize"];
    }
}

- (instancetype)initWithDataSource:(id<JXPagerSmoothViewDataSource>)dataSource pagerHeaderBounces:(BOOL)pagerHeaderBounces
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataSource = dataSource;
        _pagerHeaderBounces = pagerHeaderBounces;
        _listDict = [NSMutableDictionary dictionary];
        _listHeaderDict = [NSMutableDictionary dictionary];
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    self.pagerHeaderContainerView = [[UIView alloc] init];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _listCollectionView = [[JXPagerSmoothCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.listCollectionView.dataSource = self;
    self.listCollectionView.delegate = self;
    self.listCollectionView.pagingEnabled = YES;
    self.listCollectionView.bounces = NO;
    self.listCollectionView.showsHorizontalScrollIndicator = NO;
    self.listCollectionView.scrollsToTop = NO;
    [self.listCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:JXPagerSmoothViewCollectionViewCellIdentifier];
    if (@available(iOS 10.0, *)) {
        self.listCollectionView.prefetchingEnabled = NO;
    }
    if (@available(iOS 11.0, *)) {
        self.listCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _listCollectionView.pagerHeaderContainerView = self.pagerHeaderContainerView;
    [self addSubview:self.listCollectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.listCollectionView.frame = self.bounds;
    if (CGRectEqualToRect(self.pagerHeaderContainerView.frame, CGRectZero)) {
        [self reloadData];
    }
    if (self.singleScrollView != nil) {
        self.singleScrollView.frame = self.bounds;
    }
}

- (void)reloadData {
    self.currentListScrollView = nil;
    self.currentIndex = self.defaultSelectedIndex;
    self.syncListContentOffsetEnabled = NO;

    [self.listHeaderDict removeAllObjects];
    for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
        [[list listScrollView] removeObserver:self forKeyPath:@"contentOffset"];
        [[list listScrollView] removeObserver:self forKeyPath:@"contentSize"];
        [[list listView] removeFromSuperview];
    }
    [_listDict removeAllObjects];

    self.heightForPagerHeader = [self.dataSource heightForPagerHeaderInPagerView:self];
    self.heightForPinHeader = [self.dataSource heightForPinHeaderInPagerView:self];
    self.heightForPagerHeaderContainerView = self.heightForPagerHeader + self.heightForPinHeader;

    UIView *pagerHeader = [self.dataSource viewForPagerHeaderInPagerView:self];
    UIView *pinHeader = [self.dataSource viewForPinHeaderInPagerView:self];
    [self.pagerHeaderContainerView addSubview:pagerHeader];
    [self.pagerHeaderContainerView addSubview:pinHeader];
    
    if (self.pagerHeaderContainerView.superview == self) {
        if (self.currentPagerHeaderContainerViewY < -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset) {
            self.currentPagerHeaderContainerViewY = -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset;
        }
        self.pagerHeaderContainerView.frame = CGRectMake(0, self.currentPagerHeaderContainerViewY, self.bounds.size.width, self.heightForPagerHeaderContainerView);
    } else {
        self.pagerHeaderContainerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.heightForPagerHeaderContainerView);
    }

    pagerHeader.frame = CGRectMake(0, 0, self.bounds.size.width, self.heightForPagerHeader);
    pinHeader.frame = CGRectMake(0, self.heightForPagerHeader, self.bounds.size.width, self.heightForPinHeader);
    if (!self.pagerHeaderBounces && self.pagerHeaderContainerView.superview != self) {
        [self addSubview:self.pagerHeaderContainerView];
    }
    [self.listCollectionView setContentOffset:CGPointMake(self.listCollectionView.bounds.size.width*self.defaultSelectedIndex, 0) animated:NO];
    [self.listCollectionView reloadData];

    if ([self.dataSource numberOfListsInPagerView:self] == 0) {
        self.singleScrollView = [[UIScrollView alloc] init];
        [self addSubview:self.singleScrollView];
        [self.singleScrollView addSubview:pagerHeader];
        self.singleScrollView.contentSize = CGSizeMake(self.bounds.size.width, self.heightForPagerHeader);
    }else if (self.singleScrollView != nil) {
        [self.singleScrollView removeFromSuperview];
        self.singleScrollView = nil;
    }
}

- (void)resizePagerTopHeightAnimatable:(BOOL)animatable duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options {
    if (self.dataSource == nil) {
        return;
    }
    
    self.heightForPagerHeader = [self.dataSource heightForPagerHeaderInPagerView:self];
    self.heightForPinHeader = [self.dataSource heightForPinHeaderInPagerView:self];
    self.heightForPagerHeaderContainerView = self.heightForPagerHeader + self.heightForPinHeader;
    
    UIView *pagerHeader = [self.dataSource viewForPagerHeaderInPagerView:self];
    UIView *pinHeader = [self.dataSource viewForPinHeaderInPagerView:self];
    CGRect frame = self.pagerHeaderContainerView.frame;
    if (self.pagerHeaderContainerView.superview == self) {
        if (frame.origin.y < -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset) {
            frame.origin.y = -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset;
            self.currentPagerHeaderContainerViewY = -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset;
        }
    }
    frame.size.height = self.heightForPagerHeaderContainerView;
    
    if (animatable) {
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            [self resizePagerTopHeightWithPagerHeader:pagerHeader pinHeader:pinHeader pagerHeaderContainerViewFrame:frame];
        } completion:^(BOOL finished) { }];
    }else {
        [self resizePagerTopHeightWithPagerHeader:pagerHeader pinHeader:pinHeader pagerHeaderContainerViewFrame:frame];
    }
}

- (void)resizePagerTopHeightWithPagerHeader:(UIView *)pagerHeader pinHeader:(UIView *)pinHeader pagerHeaderContainerViewFrame:(CGRect)pagerHeaderContainerViewFrame {
    self.pagerHeaderContainerView.frame = pagerHeaderContainerViewFrame;
    pagerHeader.frame = CGRectMake(0, 0, self.bounds.size.width, self.heightForPagerHeader);
    pinHeader.frame = CGRectMake(0, self.heightForPagerHeader, self.bounds.size.width, self.heightForPinHeader);
    
    for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
        UIScrollView *scrollView = [list listScrollView];
        UIEdgeInsets contentInset = scrollView.contentInset;
        contentInset.top = self.heightForPagerHeaderContainerView;
        scrollView.contentInset = contentInset;
        UIView *header = [self listHeaderForListScrollView:scrollView];
        if (header != nil) {
            header.frame = CGRectMake(0, -self.heightForPagerHeaderContainerView, self.bounds.size.width, self.heightForPagerHeaderContainerView);
        }
        
        [[list listView] setNeedsLayout];
        [[list listView] layoutIfNeeded];
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfListsInPagerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JXPagerSmoothViewCollectionViewCellIdentifier forIndexPath:indexPath];
    id<JXPagerSmoothViewListViewDelegate> list = self.listDict[@(indexPath.item)];
    if (list == nil) {
        list = [self.dataSource pagerView:self initListAtIndex:indexPath.item];
        _listDict[@(indexPath.item)] = list;
        [[list listView] setNeedsLayout];
        [[list listView] layoutIfNeeded];
        UIScrollView *listScrollView = [list listScrollView];
        if ([listScrollView isKindOfClass:[UITableView class]]) {
            ((UITableView *)listScrollView).estimatedRowHeight = 0;
            ((UITableView *)listScrollView).estimatedSectionFooterHeight = 0;
            ((UITableView *)listScrollView).estimatedSectionHeaderHeight = 0;
        }
        if (@available(iOS 11.0, *)) {
            listScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        listScrollView.contentInset = UIEdgeInsetsMake(self.heightForPagerHeaderContainerView, listScrollView.contentInset.left, listScrollView.contentInset.bottom, listScrollView.contentInset.right);
        self.currentListInitializeContentOffsetY = -self.heightForPagerHeaderContainerView + MIN(-self.currentPagerHeaderContainerViewY, self.heightForPagerHeader - self.pinSectionHeaderVerticalOffset);
        [listScrollView setContentOffset:CGPointMake(0, self.currentListInitializeContentOffsetY) animated:NO];
        UIView *listHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -self.heightForPagerHeaderContainerView, self.bounds.size.width, self.heightForPagerHeaderContainerView)];
        [listScrollView addSubview:listHeader];
        if (self.pagerHeaderBounces && self.pagerHeaderContainerView.superview == nil) {
            [listHeader addSubview:self.pagerHeaderContainerView];
        }
        self.listHeaderDict[@(indexPath.item)] = listHeader;
        [listScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [listScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    for (id<JXPagerSmoothViewListViewDelegate> listItem in self.listDict.allValues) {
        [listItem listScrollView].scrollsToTop = (listItem == list);
    }
    UIView *listView = [list listView];
    if (listView != nil && listView.superview != cell.contentView) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        listView.frame = cell.contentView.bounds;
        [cell.contentView addSubview:listView];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self listDidAppear:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self listDidDisappear:indexPath.item];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerSmoothViewDidScroll:)]) {
        [self.delegate pagerSmoothViewDidScroll:scrollView];
    }
    CGFloat indexPercent = scrollView.contentOffset.x/scrollView.bounds.size.width;
    NSInteger index = floor(indexPercent);
    UIScrollView *listScrollView = [self.listDict[@(index)] listScrollView];
    if (indexPercent - index == 0 && index != self.currentIndex && !(scrollView.isDragging || scrollView.isDecelerating) && listScrollView.contentOffset.y <= -(self.heightForPinHeader + self.pinSectionHeaderVerticalOffset)) {
        [self horizontalScrollDidEndAtIndex:index];
    }else {
        //左右滚动的时候，就把listHeaderContainerView添加到self，达到悬浮在顶部的效果
        if (self.pagerHeaderBounces && self.pagerHeaderContainerView.superview != self) {
            self.pagerHeaderContainerView.frame = CGRectMake(0, self.currentPagerHeaderContainerViewY, self.pagerHeaderContainerView.bounds.size.width, self.pagerHeaderContainerView.bounds.size.height);
            [self addSubview:self.pagerHeaderContainerView];
        }
    }
    if (index != self.currentIndex) {
        self.currentIndex = index;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
        [self horizontalScrollDidEndAtIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [self horizontalScrollDidEndAtIndex:index];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *scrollView = (UIScrollView *)object;
        if (scrollView != nil) {
            if ([self.delegate respondsToSelector:@selector(pagerCurrentScrollViewDidScroll:)]) {
                [self.delegate pagerCurrentScrollViewDidScroll:scrollView];
            }
            [self listDidScroll:scrollView];
        }
    }else if([keyPath isEqualToString:@"contentSize"]) {
        UIScrollView *scrollView = (UIScrollView *)object;
        if (scrollView != nil) {
            CGFloat minContentSizeHeight = self.bounds.size.height - (self.heightForPinHeader + self.pinSectionHeaderVerticalOffset);
            if (minContentSizeHeight > scrollView.contentSize.height) {
                scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, minContentSizeHeight);
                //新的scrollView第一次加载的时候重置contentOffset
                if (_currentListScrollView != nil && scrollView != _currentListScrollView) {
                    [scrollView setContentOffset:CGPointMake(0, self.currentListInitializeContentOffsetY) animated:NO];
                }
            }
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Event

- (void)listDidScroll:(UIScrollView *)scrollView {
    if (self.listCollectionView.isDragging || self.listCollectionView.isDecelerating) {
        return;
    }
    NSInteger listIndex = [self listIndexForListScrollView:scrollView];
    if (listIndex != self.currentIndex) {
        return;
    }
    self.currentListScrollView = scrollView;
    CGFloat contentOffsetY = scrollView.contentOffset.y + self.heightForPagerHeaderContainerView;
    if (!self.pagerHeaderBounces && contentOffsetY <= 0) {
        self.syncListContentOffsetEnabled = YES;
        self.currentPagerHeaderContainerViewY = 0;
        for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
            if ([list listScrollView] != self.currentListScrollView) {
                if ([list listScrollView].contentOffset.y > -self.heightForPagerHeaderContainerView) {
                    [[list listScrollView] setContentOffset:CGPointMake([list listScrollView].contentOffset.x, -self.heightForPagerHeaderContainerView) animated:NO];
                }
            }
        }
        
        self.pagerHeaderContainerView.frame = CGRectMake(self.pagerHeaderContainerView.frame.origin.x, self.currentPagerHeaderContainerViewY, self.pagerHeaderContainerView.frame.size.width, self.pagerHeaderContainerView.frame.size.height);
        
        return;
    }
    if (contentOffsetY + self.pinSectionHeaderVerticalOffset < self.heightForPagerHeader) {
        self.syncListContentOffsetEnabled = YES;
        self.currentPagerHeaderContainerViewY = -contentOffsetY;
        for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
            if ([list listScrollView] != self.currentListScrollView) {
                [[list listScrollView] setContentOffset:scrollView.contentOffset animated:NO];
            }
        }
        UIView *header = [self listHeaderForListScrollView:scrollView];
        if (self.pagerHeaderBounces) {
            if (self.pagerHeaderContainerView.superview != header) {
                self.pagerHeaderContainerView.frame = CGRectMake(self.pagerHeaderContainerView.frame.origin.x, 0, self.pagerHeaderContainerView.frame.size.width, self.pagerHeaderContainerView.frame.size.height);
                [header addSubview:self.pagerHeaderContainerView];
            }
        } else {
            self.pagerHeaderContainerView.frame = CGRectMake(self.pagerHeaderContainerView.frame.origin.x, self.currentPagerHeaderContainerViewY, self.pagerHeaderContainerView.frame.size.width, self.pagerHeaderContainerView.frame.size.height);
        }
    }else {
        if (self.pagerHeaderBounces) {
            if (self.pagerHeaderContainerView.superview != self) {
                self.pagerHeaderContainerView.frame = CGRectMake(self.pagerHeaderContainerView.frame.origin.x, -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset, self.pagerHeaderContainerView.frame.size.width, self.pagerHeaderContainerView.frame.size.height);
                [self addSubview:self.pagerHeaderContainerView];
            }
        } else {
            self.pagerHeaderContainerView.frame = CGRectMake(self.pagerHeaderContainerView.frame.origin.x, -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset, self.pagerHeaderContainerView.frame.size.width, self.pagerHeaderContainerView.frame.size.height);
        }
        if (self.isSyncListContentOffsetEnabled) {
            self.syncListContentOffsetEnabled = NO;
            self.currentPagerHeaderContainerViewY = -self.heightForPagerHeader + self.pinSectionHeaderVerticalOffset;
            for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
                if ([list listScrollView] != self.currentListScrollView) {
                    [[list listScrollView] setContentOffset:CGPointMake(0, -(self.heightForPinHeader + self.pinSectionHeaderVerticalOffset)) animated:NO];
                }
            }
        }
    }
}

#pragma mark - Private

- (UIView *)listHeaderForListScrollView:(UIScrollView *)scrollView {
    for (NSNumber *index in self.listDict) {
        if ([self.listDict[index] listScrollView] == scrollView) {
            return self.listHeaderDict[index];
        }
    }
    return nil;
}

- (NSInteger)listIndexForListScrollView:(UIScrollView *)scrollView {
    for (NSNumber *index in self.listDict) {
        if ([self.listDict[index] listScrollView] == scrollView) {
            return [index integerValue];
        }
    }
    return 0;
}

- (void)listDidAppear:(NSInteger)index {
    NSUInteger count = [self.dataSource numberOfListsInPagerView:self];
    if (count <= 0 || index >= count) {
        return;
    }

    id<JXPagerSmoothViewListViewDelegate> list = self.listDict[@(index)];
    if (list && [list respondsToSelector:@selector(listDidAppear)]) {
        [list listDidAppear];
    }
}

- (void)listDidDisappear:(NSInteger)index {
    NSUInteger count = [self.dataSource numberOfListsInPagerView:self];
    if (count <= 0 || index >= count) {
        return;
    }
    id<JXPagerSmoothViewListViewDelegate> list = self.listDict[@(index)];
    if (list && [list respondsToSelector:@selector(listDidDisappear)]) {
        [list listDidDisappear];
    }
}

/// 列表左右切换滚动结束之后，需要把pagerHeaderContainerView添加到当前index的列表上面
- (void)horizontalScrollDidEndAtIndex:(NSInteger)index {
    self.currentIndex = index;
    if (self.pagerHeaderBounces) {
        UIView *listHeader = self.listHeaderDict[@(index)];
        UIScrollView *listScrollView = [self.listDict[@(index)] listScrollView];
        if (listHeader != nil && listScrollView.contentOffset.y < -(self.heightForPinHeader + self.pinSectionHeaderVerticalOffset)) {
            for (id<JXPagerSmoothViewListViewDelegate> listItem in self.listDict.allValues) {
                [listItem listScrollView].scrollsToTop = ([listItem listScrollView] == listScrollView);
            }
            self.pagerHeaderContainerView.frame = CGRectMake(0, 0, self.pagerHeaderContainerView.bounds.size.width, self.pagerHeaderContainerView.bounds.size.height);
            [listHeader addSubview:self.pagerHeaderContainerView];
        }
    }
}

@end
