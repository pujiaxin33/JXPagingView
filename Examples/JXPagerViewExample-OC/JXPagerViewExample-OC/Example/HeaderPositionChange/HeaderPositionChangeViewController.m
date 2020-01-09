//
//  HeaderPositionChangeViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/1/9.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "HeaderPositionChangeViewController.h"

@interface HeaderPositionChangeViewController ()

@end

@implementation HeaderPositionChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(didNaviRightItemClick)];
}

- (void)didNaviRightItemClick {
    if (self.pagerView.pinSectionHeaderVerticalOffset == JXTableHeaderViewHeight) {
        self.pagerView.pinSectionHeaderVerticalOffset = 0;
    }else {
        self.pagerView.pinSectionHeaderVerticalOffset = JXTableHeaderViewHeight;
    }
    [self.pagerView reloadData];
}


@end
