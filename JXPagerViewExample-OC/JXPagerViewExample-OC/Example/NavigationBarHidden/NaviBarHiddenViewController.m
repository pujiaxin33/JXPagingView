//
//  NaviBarHiddenViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "NaviBarHiddenViewController.h"

@interface NaviBarHiddenViewController ()
@property (nonatomic, strong) UIView *naviBGView;
@property (nonatomic, assign) CGFloat pinHeaderViewInsetTop;
@end

@implementation NaviBarHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat topSafeMargin = 20;
    if (@available(iOS 11.0, *)) {
        if ([UIScreen mainScreen].bounds.size.height == 812) {
            topSafeMargin = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
        }
    }
    CGFloat naviHeight = topSafeMargin + 44;
    self.pinHeaderViewInsetTop = naviHeight;

    self.naviBGView = [[UIView alloc] init];
    self.naviBGView.alpha = 0;
    self.naviBGView.backgroundColor = [UIColor whiteColor];
    self.naviBGView.frame = CGRectMake(0, 0, self.view.bounds.size.width, naviHeight);
    [self.view addSubview:self.naviBGView];

    UILabel *naviTitleLabel = [[UILabel alloc] init];
    naviTitleLabel.text = @"导航栏隐藏";
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.frame = CGRectMake(0, topSafeMargin, self.view.bounds.size.width, 44);
    [self.naviBGView addSubview:naviTitleLabel];

    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    back.frame = CGRectMake(12, topSafeMargin, 44, 44);
    [back addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBGView addSubview:back];

    //让mainTableView可以显示范围外
    self.pagerView.mainTableView.clipsToBounds = false;
    //让头图的布局往上移动naviHeight高度，填充导航栏下面的内容
    self.userHeaderView.imageView.frame = CGRectMake(0, -naviHeight, self.view.bounds.size.width, naviHeight + JXTableHeaderViewHeight);
}

- (void)backButtonClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    //pagingView依然是从导航栏下面开始布局的
    self.pagerView.frame = CGRectMake(0, self.pinHeaderViewInsetTop, self.view.bounds.size.width, self.view.bounds.size.height - self.pinHeaderViewInsetTop);
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = 100;
    CGFloat percent = scrollView.contentOffset.y/thresholdDistance;
    percent = MAX(0, MIN(1, percent));
    self.naviBGView.alpha = percent;
}

@end
