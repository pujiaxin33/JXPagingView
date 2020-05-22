//
//  DynamicHeaderViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/5/22.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "DynamicHeaderViewController.h"
#import "DynamicHeader.h"

@interface DynamicHeaderViewController ()
@property (nonatomic, strong) DynamicHeader *myHeader;
@property (nonatomic, assign) CGFloat headerHeight;
@end

@implementation DynamicHeaderViewController

- (void)viewDidLoad {
    _myHeader = [[DynamicHeader alloc] initWithFrame:self.view.bounds];
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    self.myHeader.didRequested = ^(CGFloat height) {
        weakSelf.headerHeight = height;
        [weakSelf.pagerView resizeTableHeaderViewHeightWithAnimatable:NO duration:0 curve:0];
        NSLog(@"%f", height);
    };

    UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
    container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.navigationController.view addSubview:container];

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = self.view.center;
    [container addSubview:indicator];
    [indicator startAnimating];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [indicator stopAnimating];
        [container removeFromSuperview];
        [self.myHeader startRequest];
    });
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.myHeader;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerHeight;
}

@end
