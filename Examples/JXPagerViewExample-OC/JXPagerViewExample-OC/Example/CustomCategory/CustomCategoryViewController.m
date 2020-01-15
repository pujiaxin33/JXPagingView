//
//  CustomCategoryViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/1/15.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "CustomCategoryViewController.h"

@interface CustomCategoryViewController ()
@property (nonatomic, strong) UIView *customCategoryView;
@end

@implementation CustomCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customCategoryView = [[UIView alloc] init];

    CGFloat buttonWidth = self.view.bounds.size.width/2;
    self.customCategoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, JXheightForHeaderInSection);

    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstButton addTarget:self action:@selector(firstButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [firstButton setTitle:@"第一个" forState:UIControlStateNormal];
    [firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    firstButton.frame = CGRectMake(0, 0, buttonWidth, JXheightForHeaderInSection);
    [self.customCategoryView addSubview:firstButton];

    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondButton addTarget:self action:@selector(secondButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [secondButton setTitle:@"第二个" forState:UIControlStateNormal];
    [secondButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    secondButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, JXheightForHeaderInSection);
    [self.customCategoryView addSubview:secondButton];
}

- (void)firstButtonDidClicked:(UIButton *)button {
    [self.pagerView.listContainerView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.pagerView.listContainerView didClickSelectedItemAtIndex:0];
}

- (void)secondButtonDidClicked:(UIButton *)button {
    CGFloat scrollViewWidth = self.pagerView.listContainerView.scrollView.bounds.size.width;
    [self.pagerView.listContainerView.scrollView setContentOffset:CGPointMake(scrollViewWidth, 0) animated:YES];
    [self.pagerView.listContainerView didClickSelectedItemAtIndex:1];
}

#pragma mark - JXPagerViewDelegate

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.customCategoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return 2;
}

@end
