//
//  NaviBarHiddenViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "NaviBarHiddenViewController.h"
#import "UIWindow+JXSafeArea.h"
#import "MJRefresh.h"

@interface NaviBarHiddenViewController ()
@property (nonatomic, strong) UIView *naviBGView;
@end

@implementation NaviBarHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat topSafeMargin = [UIApplication.sharedApplication.keyWindow jx_layoutInsets].top;
    CGFloat naviHeight = [UIApplication.sharedApplication.keyWindow jx_navigationHeight];
    self.pagerView.pinSectionHeaderVerticalOffset = naviHeight;

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

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = 100;
    CGFloat percent = scrollView.contentOffset.y/thresholdDistance;
    percent = MAX(0, MIN(1, percent));
    self.naviBGView.alpha = percent;
}

@end
