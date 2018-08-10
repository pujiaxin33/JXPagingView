//
//  JXCategoryView.h
//  UI系列测试
//
//  Created by jiaxin on 2018/3/15.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXCategoryBaseView;
@class JXCategoryBaseCellModel;

extern const CGFloat JXCategoryViewAutomaticDimension;

@protocol JXCategoryViewDelegate <NSObject>

@optional
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface JXCategoryBaseView : UIView

@property (nonatomic, strong) NSArray <JXCategoryBaseCellModel *>*dataSource;

@property (nonatomic, weak) id<JXCategoryViewDelegate>delegate;

@property (nonatomic, strong) UIScrollView *contentScrollView;    //需要关联的contentScrollView

@property (nonatomic, assign) NSInteger defaultSelectedIndex;

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

@property (nonatomic, assign) CGFloat cellContentMargin;

@property (nonatomic, strong) UIColor *indicatorLineColor;      //底部指示器lineView颜色

@property (nonatomic, assign) CGFloat indicatorLineWidth;    //默认JXCategoryViewAutomaticDimension

@property (nonatomic, assign) CGFloat cellWidth;    //默认JXCategoryViewAutomaticDimension

@property (nonatomic, assign) BOOL indicatorLineViewShowEnabled;     //默认为YES

@property (nonatomic, assign) BOOL indicatorViewScrollEnabled;   //指示器lineView、backEllipseLayer切换时是否支持滚动，默认为YES

@property (nonatomic, assign) BOOL backEllipseLayerShowEnabled;     //默认为NO

@property (nonatomic, assign) CGSize backEllipseLayerSize;  //默认CGSizeMake(30, 15)；backEllipseLayer放置在cell center，只需要配置size即可

@property (nonatomic, assign) CGFloat backEllipseLayerCornerRadius; //默认3

@property (nonatomic, strong) UIColor *backEllipseLayerFillColor;   //默认为[UIColor yellowColor]

@property (nonatomic, assign) BOOL zoomEnabled;     //默认为NO

@property (nonatomic, assign) CGFloat zoomScale;    //默认1.2，zoomEnabled为YES才生效

@property (nonatomic, assign) BOOL separatorLineShowEnabled;    //默认为NO

- (void)reloadDatas;    //初始化的时候无需调用。初始化之后更新其他配置属性，需要调用该方法，进行刷新。

- (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;

- (void)selectItemWithIndex:(NSInteger)index;

#pragma mark - Subclass Override

- (void)initializeDatas;

- (void)initializeViews;

- (CGFloat)preferredCellWidthWithIndex:(NSInteger)index;

- (Class)preferredCellClass;

- (void)preferredRefreshLeftCellModel:(JXCategoryBaseCellModel *)leftCellModel rightCellModel:(JXCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio;

- (void)preferredRefreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index;

@end
