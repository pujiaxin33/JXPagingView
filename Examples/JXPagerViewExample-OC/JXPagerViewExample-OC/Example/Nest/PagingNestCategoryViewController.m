//
//  NestViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/10/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

#import "PagingNestCategoryViewController.h"
#import "JXCategoryView.h"
#import "JXPagerListRefreshView.h"
#import "PagingViewTableHeaderView.h"
#import "PagingNestCategoryListViewController.h"

static const CGFloat JXTableHeaderViewHeight = 200;
static const CGFloat JXheightForHeaderInSection = 50;

@interface PagingNestCategoryViewController () <JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXPagerListRefreshView *pagerView;
@property (nonatomic, strong) PagingViewTableHeaderView *userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation PagingNestCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    _titles = @[@"主题一", @"主题二", @"主题三"];

    _userHeaderView = [[PagingViewTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 50)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor greenColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelZoomScale = 1.2;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorWidth = 30;
    self.categoryView.indicators = @[lineView];

    //如果不想要下拉刷新的效果，改用JXPagerView类即可
    _pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];

    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pagerView.frame = self.view.bounds;
}

#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.userHeaderView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return JXTableHeaderViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return JXheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    PagingNestCategoryListViewController *list = [[PagingNestCategoryListViewController alloc] init];
    return list;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {

}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {

}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self checkIsNestContentScrollView:(UIScrollView *)gestureRecognizer.view] || [self checkIsNestContentScrollView:(UIScrollView *)otherGestureRecognizer.view]) {
        //如果交互的是嵌套的contentScrollView，证明在左右滑动，就不允许同时响应
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (BOOL)checkIsNestContentScrollView:(UIScrollView *)scrollView {
    for (PagingNestCategoryListViewController *list in self.pagerView.validListDict.allValues) {
        if (list.contentScrollView == scrollView) {
            return YES;
        }
    }
    return NO;
}

@end
