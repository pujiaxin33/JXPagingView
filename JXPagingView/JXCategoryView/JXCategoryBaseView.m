//
//  JXCategoryBaseView.m
//  UI系列测试
//
//  Created by jiaxin on 2018/3/15.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXCategoryBaseView.h"
#import "JXCategoryBaseCell.h"
#import "JXCategoryBaseCellModel.h"
#import "UIColor+JXAdd.h"
#import "JXCategoryCollectionView.h"

const CGFloat JXCategoryViewAutomaticDimension = -1;
static const NSInteger JXCategoryViewClickedIndexUnknown = -1;

@interface JXCategoryBaseView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) JXCategoryCollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) NSInteger clickedItemIndex;
@property (nonatomic, strong) CAShapeLayer *ellipseLayer;

@end

@implementation JXCategoryBaseView

- (void)dealloc
{
    if (self.contentScrollView) {
        [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDatas];
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeDatas];
        [self initializeViews];
    }
    return self;
}

- (void)initializeDatas
{
    _dataSource = [NSMutableArray array];
    _selectedIndex = 0;
    _indicatorLineColor = [UIColor whiteColor];
    _lineHeight = 2;
    _indicatorLineWidth = JXCategoryViewAutomaticDimension;
    _cellWidth = JXCategoryViewAutomaticDimension;
    _cellContentMargin = 10;
    _indicatorViewScrollEnabled = YES;
    _clickedItemIndex = JXCategoryViewClickedIndexUnknown;
    _zoomEnabled = NO;
    _zoomScale = 1.2;
    _indicatorLineViewShowEnabled = YES;
    _backEllipseLayerSize = CGSizeMake(30, 15);
    _backEllipseLayerCornerRadius = 3.0;
    _backEllipseLayerShowEnabled = NO;
    _separatorLineShowEnabled = NO;
}

- (void)initializeViews
{
    self.backgroundColor = [UIColor lightGrayColor];
    JXCategoryCollectionView *collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        JXCategoryCollectionView *collectionView = [[JXCategoryCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[self preferredCellClass] forCellWithReuseIdentifier:NSStringFromClass([self preferredCellClass])];
        collectionView;
    });
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
    self.lineView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = self.indicatorLineColor;
        view;
    });
    [self.collectionView insertSubview:self.lineView atIndex:0];

    _ellipseLayer = [CAShapeLayer layer];
    _ellipseLayer.fillColor = [UIColor yellowColor].CGColor;
    [self.collectionView.layer insertSublayer:_ellipseLayer atIndex:0];
    self.collectionView.backEllipseLayer = _ellipseLayer;
}

- (void)setDefaultSelectedIndex:(NSInteger)defaultSelectedIndex
{
    _defaultSelectedIndex = defaultSelectedIndex;

    _selectedIndex = defaultSelectedIndex;
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView
{
    _contentScrollView = contentScrollView;

    [contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)reloadDatas {
    [self setNeedsLayout];
}

- (void)refreshDatas {
    _selectedIndex = MIN(self.dataSource.count, _selectedIndex);
    if (self.dataSource.count == 1) {
        _indicatorLineViewShowEnabled = NO;
    }
    CGFloat totalItemWidth = 0;
    for (int i = 0; i < self.dataSource.count; i++) {
        JXCategoryBaseCellModel *cellModel = self.dataSource[i];
        cellModel.zoomEnabled = self.zoomEnabled;
        cellModel.zoomScale = 1.0;
        cellModel.sepratorLineShowEnabled = self.separatorLineShowEnabled;
        if (i == self.dataSource.count - 1) {
            //最后一个都不显示分隔符
            cellModel.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            cellModel.selected = YES;
            cellModel.zoomScale = self.zoomScale;
        }
        cellModel.cellWidth = [self preferredCellWidthWithIndex:i] + _cellContentMargin*2;
        totalItemWidth += cellModel.cellWidth;
        [self preferredRefreshCellModel:cellModel index:i];
    }
    if (totalItemWidth < self.bounds.size.width) {
        CGFloat compensationWidth = (self.bounds.size.width - totalItemWidth)/self.dataSource.count;
        [self.dataSource enumerateObjectsUsingBlock:^(JXCategoryBaseCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.cellWidth += compensationWidth;
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.collectionView.frame = self.bounds;
    if (self.dataSource.count <= 0) {
        return;
    }

    [self refreshDatas];

    __block CGFloat frameXOfLineView = 0;
    __block CGFloat frameXOfBackEllipseLayer = 0;
    __block CGFloat frameXOfSelectedCell = 0;
    __block CGFloat selectedCellWidth = 0;
    __block CGFloat totalCellWidth = 0;
    [self.dataSource enumerateObjectsUsingBlock:^(JXCategoryBaseCellModel * cellModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.selectedIndex) {
            frameXOfLineView += cellModel.cellWidth;
            frameXOfBackEllipseLayer += cellModel.cellWidth;
            frameXOfSelectedCell += cellModel.cellWidth;
        }else if (idx == self.selectedIndex) {
            frameXOfLineView += cellModel.cellWidth/2.0 - [self getLineWithWithIndex:self.selectedIndex]/2.0 ;
            frameXOfBackEllipseLayer += (cellModel.cellWidth - _backEllipseLayerSize.width)/2.0;
            selectedCellWidth = cellModel.cellWidth;
        }
        totalCellWidth += cellModel.cellWidth;
    }];

    self.lineView.backgroundColor = self.indicatorLineColor;
    self.lineView.frame = CGRectMake(frameXOfLineView, self.bounds.size.height - self.lineHeight, [self getLineWithWithIndex:self.selectedIndex], self.lineHeight);
    self.ellipseLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(frameXOfBackEllipseLayer, (self.bounds.size.height - _backEllipseLayerSize.height)/2.0, _backEllipseLayerSize.width, _backEllipseLayerSize.height) cornerRadius:_backEllipseLayerCornerRadius].CGPath;
    self.lineView.hidden = !self.indicatorLineViewShowEnabled;
    self.ellipseLayer.hidden = !self.backEllipseLayerShowEnabled;

    [self.contentScrollView setContentOffset:CGPointMake(self.selectedIndex*self.contentScrollView.bounds.size.width, 0) animated:NO];
    CGFloat minX = 0;
    CGFloat maxX = totalCellWidth - self.bounds.size.width;
    CGFloat targetX = frameXOfSelectedCell - self.bounds.size.width/2.0 + selectedCellWidth/2.0;
    [self.collectionView setContentOffset:CGPointMake(MAX(MIN(maxX, targetX), minX), 0) animated:NO];

    self.lineView.backgroundColor = _indicatorLineColor;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _ellipseLayer.fillColor = _backEllipseLayerFillColor.CGColor;
    [CATransaction commit];

    [self.collectionView reloadData];
}

- (void)selectItemWithIndex:(NSInteger)index {
    self.clickedItemIndex = index;
    [self selectedTargetCellWithIndex:index];
    [self.contentScrollView setContentOffset:CGPointMake(index*self.contentScrollView.bounds.size.width, 0) animated:YES];

    UICollectionViewCell *clickedCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];

    UIBezierPath *toPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(clickedCell.frame.origin.x + (clickedCell.bounds.size.width - _backEllipseLayerSize.width)/2.0, (self.bounds.size.height - _backEllipseLayerSize.height)/2.0, _backEllipseLayerSize.width, _backEllipseLayerSize.height) cornerRadius:_backEllipseLayerCornerRadius];
    CGRect lineBounds = self.lineView.bounds;
    CGPoint lineCenter = self.lineView.center;
    lineCenter.x = clickedCell.center.x;
    if (self.indicatorLineWidth == JXCategoryViewClickedIndexUnknown) {
        lineBounds.size.width = clickedCell.bounds.size.width;
    }
    if (self.indicatorViewScrollEnabled) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (__bridge id _Nullable)(self.ellipseLayer.path);
        animation.toValue = (__bridge id _Nullable)toPath.CGPath;
        animation.duration = 0.3;
        [self.ellipseLayer addAnimation:animation forKey:@"move"];
        self.ellipseLayer.path = toPath.CGPath;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineView.bounds = lineBounds;
            self.lineView.center = lineCenter;
        }];
    }else {
        self.ellipseLayer.path = toPath.CGPath;
        self.lineView.bounds = lineBounds;
        self.lineView.center = lineCenter;
    }
}


#pragma mark - Subclass Override

- (CGFloat)preferredCellWidthWithIndex:(NSInteger)index {
    return 0;
}

- (Class)preferredCellClass {
    return JXCategoryBaseCell.class;
}

- (void)preferredRefreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {

}

- (void)preferredRefreshLeftCellModel:(JXCategoryBaseCellModel *)leftCellModel rightCellModel:(JXCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {

}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self preferredCellClass]) forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JXCategoryBaseCell *categoryCell = (JXCategoryBaseCell *)cell;
    [categoryCell reloadDatas:self.dataSource[indexPath.item]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectItemWithIndex:indexPath.row];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JXCategoryBaseCellModel *cellModel = self.dataSource[indexPath.item];
    return CGSizeMake(cellModel.cellWidth, self.bounds.size.height);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"contentOffset"] && (self.contentScrollView.isDragging || self.contentScrollView.isDecelerating)) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
        //限制最大最小
        ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
        NSInteger baseIndex = floorf(ratio);
        CGFloat remainderRatio = ratio - baseIndex;
        CGFloat totalX = 0;
        CGFloat totalXOfBackEllipseLayer = 0;
        CGFloat targetindicatorLineWidth = [self getLineWithWithIndex:baseIndex];
        CGFloat targetCellWidth = 0;

        if (remainderRatio == 0) {
            CGRect cellFrame = [self getTargetCellFrame:baseIndex];
            totalX = cellFrame.origin.x + cellFrame.size.width/2.0;
            totalXOfBackEllipseLayer = totalX;
            totalXOfBackEllipseLayer -= _backEllipseLayerSize.width/2.0;
            totalX -= targetindicatorLineWidth/2.0;
            targetCellWidth = cellFrame.size.width;
            [self selectedTargetCellWithIndex:baseIndex];
        }else {

            JXCategoryBaseCellModel *leftCellModel = self.dataSource[baseIndex];
            JXCategoryBaseCellModel *rightCellModel = self.dataSource[baseIndex + 1];
            //处理缩放
            if (self.zoomEnabled) {
                leftCellModel.zoomScale = [self interpolationFrom:self.zoomScale to:1.0 percent:remainderRatio];
                rightCellModel.zoomScale = [self interpolationFrom:1.0 to:self.zoomScale percent:remainderRatio];
            }

            [self preferredRefreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:remainderRatio];

            JXCategoryBaseCell *leftCell = (JXCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
            [leftCell reloadDatas:leftCellModel];

            JXCategoryBaseCell *rightCell = (JXCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex + 1 inSection:0]];
            [rightCell reloadDatas:rightCellModel];

            CGRect leftCellFrame = [self getTargetCellFrame:baseIndex];
            CGRect rightCellFrame = [self getTargetCellFrame:baseIndex+1];

            totalX = [self interpolationFrom:(leftCellFrame.origin.x + leftCellFrame.size.width/2.0) to:(rightCellFrame.origin.x + rightCellFrame.size.width/2.0) percent:remainderRatio];
            if (self.indicatorLineWidth == JXCategoryViewAutomaticDimension) {
                targetindicatorLineWidth = [self interpolationFrom:leftCellFrame.size.width to:rightCellFrame.size.width percent:remainderRatio];
            }
            totalXOfBackEllipseLayer = totalX;
            totalXOfBackEllipseLayer -= _backEllipseLayerSize.width/2.0;
            totalX -= targetindicatorLineWidth/2.0;
            targetCellWidth = [self interpolationFrom:leftCellFrame.size.width to:rightCellFrame.size.width percent:remainderRatio];
        }

        if (self.indicatorViewScrollEnabled == YES ||
            (self.indicatorViewScrollEnabled == NO && remainderRatio == 0)) {

            self.ellipseLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(totalXOfBackEllipseLayer, (self.bounds.size.height - _backEllipseLayerSize.height)/2.0, _backEllipseLayerSize.width, _backEllipseLayerSize.height) cornerRadius:_backEllipseLayerCornerRadius].CGPath;

            CGRect frame = self.lineView.frame;
            frame.origin.x = totalX;
            frame.size.width = targetindicatorLineWidth;
            self.lineView.frame = frame;
        }
    }
}

#pragma mark - Private

- (void)selectedTargetCellWithIndex:(NSInteger)targetIndex
{
    if (targetIndex == self.selectedIndex) {
        return;
    }

    JXCategoryBaseCell *lastCell = (JXCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    JXCategoryBaseCellModel *lastCellModel = self.dataSource[self.selectedIndex];
    lastCellModel.selected = NO;
    lastCellModel.zoomScale = 1.0;
    [lastCell reloadDatas:lastCellModel];

    JXCategoryBaseCell *cell = (JXCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0]];
    JXCategoryBaseCellModel *cellModel = self.dataSource[targetIndex];
    cellModel.selected = YES;
    cellModel.zoomScale = self.zoomScale;
    [cell reloadDatas:cellModel];

    self.selectedIndex = targetIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    self.clickedItemIndex = JXCategoryViewClickedIndexUnknown;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(categoryView:didSelectedItemAtIndex:)]) {
        [self.delegate categoryView:self didSelectedItemAtIndex:targetIndex];
    }
}

- (CGFloat)getLineWithWithIndex:(NSInteger)index
{
    if (_indicatorLineWidth == JXCategoryViewAutomaticDimension) {
        JXCategoryBaseCellModel *cellModel = self.dataSource[index];
        return cellModel.cellWidth;
    }
    return _indicatorLineWidth;
}

- (CGRect)getTargetCellFrame:(NSInteger)targetIndex
{
    CGFloat x = 0;
    for (int i = 0; i < targetIndex; i ++) {
        JXCategoryBaseCellModel *cellModel = self.dataSource[i];
        x += cellModel.cellWidth;
    }
    CGFloat width = [(JXCategoryBaseCellModel *)self.dataSource[targetIndex] cellWidth];
    return CGRectMake(x, 0, width, self.bounds.size.height);
}

- (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

@end
