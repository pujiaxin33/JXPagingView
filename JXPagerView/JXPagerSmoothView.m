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
@property (nonatomic, assign) CGFloat heightForPagerHeader;
@property (nonatomic, assign) CGFloat heightForPinHeader;
@property (nonatomic, assign) CGFloat heightForPagerHeaderContainerView;
@end

@implementation JXPagerSmoothView

- (void)dealloc
{
    for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
        [[list listScrollView] removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (instancetype)initWithDataSource:(id<JXPagerSmoothViewDataSource>)dataSource
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataSource = dataSource;
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
}

- (void)reloadData {
    self.currentListScrollView = nil;
    self.currentIndex = self.defaultSelectedIndex;
    self.currentPagerHeaderContainerViewY = 0;
    self.syncListContentOffsetEnabled = NO;

    [self.listHeaderDict removeAllObjects];
    for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
        [[list listScrollView] removeObserver:self forKeyPath:@"contentOffset"];
        [list.listView removeFromSuperview];
    }
    [_listDict removeAllObjects];

    self.heightForPagerHeader = [self.dataSource heightForPagerHeaderInPagerView:self];
    self.heightForPinHeader = [self.dataSource heightForPinHeaderInPagerView:self];
    self.heightForPagerHeaderContainerView = self.heightForPagerHeader + self.heightForPinHeader;

    UIView *pagerHeader = [self.dataSource viewForPagerHeaderInPagerView:self];
    UIView *pinHeader = [self.dataSource ViewForPinHeaderInPagerView:self];
    [self.pagerHeaderContainerView addSubview:pagerHeader];
    [self.pagerHeaderContainerView addSubview:pinHeader];

    self.pagerHeaderContainerView.frame = CGRectMake(0, 0, self.bounds.size.width, self.heightForPagerHeaderContainerView);
    pagerHeader.frame = CGRectMake(0, 0, self.bounds.size.width, self.heightForPagerHeader);
    pinHeader.frame = CGRectMake(0, self.heightForPagerHeader, self.bounds.size.width, self.heightForPinHeader);
    [self.listCollectionView setContentOffset:CGPointMake(self.listCollectionView.bounds.size.width*self.defaultSelectedIndex, 0) animated:NO];
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
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    id<JXPagerSmoothViewListViewDelegate> list = self.listDict[@(indexPath.item)];
    if (list == nil) {
        list = [self.dataSource pagerView:self initListAtIndex:indexPath.item];
        _listDict[@(indexPath.item)] = list;
        [[list listView] setNeedsLayout];
        [[list listView] layoutIfNeeded];
        UIScrollView *listScrollView = [list listScrollView];
        listScrollView.contentInset = UIEdgeInsetsMake(self.heightForPagerHeaderContainerView, 0, 0, 0);
        listScrollView.contentOffset = CGPointMake(0, -listScrollView.contentInset.top + MIN(-self.currentPagerHeaderContainerViewY, self.heightForPagerHeader));
        UIView *listHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -self.heightForPagerHeaderContainerView, self.bounds.size.width, self.heightForPagerHeaderContainerView)];
        [listScrollView addSubview:listHeader];
        if (self.pagerHeaderContainerView.superview == nil) {
            [listHeader addSubview:self.pagerHeaderContainerView];
        }
        self.listHeaderDict[@(indexPath.item)] = listHeader;
        [listScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)([list listScrollView])];
    }
    for (id<JXPagerSmoothViewListViewDelegate> listItem in self.listDict.allValues) {
        if (listItem == list) {
            [listItem listScrollView].scrollsToTop = YES;
        }else {
            [listItem listScrollView].scrollsToTop = NO;
        }
    }

    UIView *listView = [list listView];
    if (listView != nil) {
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
    //左右滚动的时候，就把listHeaderContainerView添加到self，达到悬浮在顶部的效果
    if (self.pagerHeaderContainerView.superview != self) {
        self.pagerHeaderContainerView.frame = CGRectMake(0, self.currentPagerHeaderContainerViewY, self.pagerHeaderContainerView.bounds.size.width, self.pagerHeaderContainerView.bounds.size.height);
        [self addSubview:self.pagerHeaderContainerView];
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
        UIScrollView *scrollView = (__bridge UIScrollView *)context;
        if (scrollView != nil) {
            [self listDidScroll:scrollView];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Event

- (void)listDidScroll:(UIScrollView *)scrollView {
//    for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
//        UIScrollView *listScrollView = [list listScrollView];
//        if (listScrollView != scrollView && (listScrollView.isDragging || listScrollView.isDecelerating)) {
//            [listScrollView setContentOffset:listScrollView.contentOffset animated:NO];
//        }
//    }
    //用户引起的滚动才处理
    if (!(scrollView.isTracking || scrollView.isDecelerating)) {
        return;
    }
    self.currentListScrollView = scrollView;
    CGFloat contentOffsetY = scrollView.contentOffset.y + self.heightForPagerHeaderContainerView;
    if (contentOffsetY <= self.heightForPagerHeader) {
        self.syncListContentOffsetEnabled = YES;
        self.currentPagerHeaderContainerViewY = -contentOffsetY;
        for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
            if ([list listScrollView] != self.currentListScrollView) {
                [list listScrollView].contentOffset = scrollView.contentOffset;
            }
        }
        UIView *listHeader = [self listHeaderForListScrollView:scrollView];
        if (self.pagerHeaderContainerView.superview != listHeader) {
            self.pagerHeaderContainerView.frame = CGRectMake(0, 0, self.pagerHeaderContainerView.bounds.size.width, self.pagerHeaderContainerView.bounds.size.height);
            [listHeader addSubview:self.pagerHeaderContainerView];
        }
    }else {
        if (self.pagerHeaderContainerView.superview != self) {
            self.pagerHeaderContainerView.frame = CGRectMake(0, -self.heightForPagerHeader, self.pagerHeaderContainerView.bounds.size.width, self.pagerHeaderContainerView.bounds.size.height);
            [self addSubview:self.pagerHeaderContainerView];
        }
        if (self.isSyncListContentOffsetEnabled) {
            self.syncListContentOffsetEnabled = NO;
            self.currentPagerHeaderContainerViewY = -self.heightForPagerHeader;
            for (id<JXPagerSmoothViewListViewDelegate> list in self.listDict.allValues) {
                if ([list listScrollView] != scrollView) {
                    [list listScrollView].contentOffset = CGPointMake(0, -self.heightForPinHeader);
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

- (void)listDidAppear:(NSInteger)index {
    NSUInteger count = [self.dataSource numberOfListsInPagerView:self];
    if (count <= 0 || index >= count) {
        return;
    }
    self.currentIndex = index;

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
    UIView *listHeader = self.listHeaderDict[@(index)];
    UIScrollView *listScrollView = [self.listDict[@(index)] listScrollView];
    if (listHeader != nil && listScrollView.contentOffset.y <= -self.heightForPinHeader) {
        self.pagerHeaderContainerView.frame = CGRectMake(0, 0, self.pagerHeaderContainerView.bounds.size.width, self.pagerHeaderContainerView.bounds.size.height);
        [listHeader addSubview:self.pagerHeaderContainerView];
    }
}

@end

