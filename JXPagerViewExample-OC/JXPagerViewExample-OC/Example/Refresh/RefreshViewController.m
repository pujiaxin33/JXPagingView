//
//  RefreshViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "RefreshViewController.h"
#import "MJRefresh.h"

@interface RefreshViewController ()

@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (TestListBaseView *listView in self.listViewArray) {
        listView.isNeedFooter = YES;
    }

    __weak typeof(self)weakSelf = self;
    self.pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.pagerView.mainTableView.mj_header endRefreshing];
        });
    }];
}


@end
