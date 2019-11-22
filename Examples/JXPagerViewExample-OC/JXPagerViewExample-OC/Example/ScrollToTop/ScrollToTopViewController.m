//
//  ScrollToTopViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/6/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "ScrollToTopViewController.h"

@interface ScrollToTopViewController ()

@end

@implementation ScrollToTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"滚到顶部" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToTargetItem)];
}

- (void)scrollToTargetItem {
    //必须让self.pagerView.currentScrollingListView滚动到顶部，才能触发main列表的滚动所以这里的animated必须是NO
    [self.pagerView.currentScrollingListView setContentOffset:CGPointZero animated:NO];
    //然后让self.pagerView.mainTableView滚动到顶部，这里的animated可以为YES
    [self.pagerView.mainTableView setContentOffset:CGPointZero animated:NO];
}

@end
