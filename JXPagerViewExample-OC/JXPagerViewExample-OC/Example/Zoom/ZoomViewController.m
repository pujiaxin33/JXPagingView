//
//  ZoomViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ZoomViewController.h"

@implementation ZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"滚动列表" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToTargetItem)];
}

- (void)scrollToTargetItem {
    //1、必须让self.pagerView.mainTableView滚动到headerView刚好消失不见，才能触发列表的滚动
    [self.pagerView.mainTableView setContentOffset:CGPointMake(0, JXTableHeaderViewHeight) animated:NO];
    UITableView *listView = (UITableView *)self.listViewArray.firstObject.listScrollView;
    [listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.userHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
}

@end
