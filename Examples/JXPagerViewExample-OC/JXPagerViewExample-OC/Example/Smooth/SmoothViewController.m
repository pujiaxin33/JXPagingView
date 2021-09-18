//
//  SmoothViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/15.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "SmoothViewController.h"
#import "SmoothListViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "SmoothListCollectionViewController.h"
#import "SmoothListScrollViewController.h"
#import "SmoothViewDefines.h"

@interface SmoothViewController () <JXPagerSmoothViewDataSource>
@property (nonatomic, strong) UIImageView *headerView;
@end

@implementation SmoothViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.type = SmoothListType_TableView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    
    self.pager = [[JXPagerSmoothView alloc] initWithDataSource:self pagerHeaderBounces:YES];
    [self.view addSubview:self.pager];

    _categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.titles = @[@"能力", @"爱好", @"队友"];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorWidth = 30;
    self.categoryView.indicators = @[lineView];

    self.headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei.jpg"]];
    self.headerView.contentMode = UIViewContentModeScaleAspectFill;

    self.categoryView.contentScrollView = self.pager.listCollectionView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pager.frame = self.view.bounds;
}

#pragma mark - JXPagerSmoothViewDataSource

- (CGFloat)heightForPagerHeaderInPagerView:(JXPagerSmoothView *)pagerView {
    return 300;
}

- (UIView *)viewForPagerHeaderInPagerView:(JXPagerSmoothView *)pagerView {
    return self.headerView;
}

- (CGFloat)heightForPinHeaderInPagerView:(JXPagerSmoothView *)pagerView {
    return SmoothViewPinCategoryHeight;
}

- (UIView *)viewForPinHeaderInPagerView:(JXPagerSmoothView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerSmoothView *)pagerView {
    return self.categoryView.titles.count;
}

- (id<JXPagerSmoothViewListViewDelegate>)pagerView:(JXPagerSmoothView *)pagerView initListAtIndex:(NSInteger)index {
    switch (self.type) {
        case SmoothListType_TableView: {
            SmoothListViewController *listVC = [[SmoothListViewController alloc] init];
            listVC.title = self.categoryView.titles[index];
            return listVC;
            break;
        }
        case SmoothListType_CollectionView: {
            SmoothListCollectionViewController *listVC = [[SmoothListCollectionViewController alloc] init];
            listVC.title = self.categoryView.titles[index];
            return listVC;
            break;
        }
        case SmoothListType_ScrollView: {
            SmoothListScrollViewController *listVC = [[SmoothListScrollViewController alloc] init];
            listVC.title = self.categoryView.titles[index];
            return listVC;
            break;
        }
    }
}

@end
