//
//  ListRefreshViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ListRefreshViewController.h"
#import "JXPagerListRefreshView.h"

@interface ListRefreshViewController ()

@end

@implementation ListRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (TestListBaseView *listView in self.listViewArray) {
        listView.isNeedHeader = YES;
    }

}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerListRefreshView alloc] initWithDelegate:self];
}


@end
