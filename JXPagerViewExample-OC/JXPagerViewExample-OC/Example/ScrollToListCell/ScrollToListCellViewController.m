//
//  ScrollToListCellViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/6/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "ScrollToListCellViewController.h"

@interface ScrollToListCellViewController ()

@end

@implementation ScrollToListCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"滚至列表Cell" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToTargetItem)];
}

- (void)scrollToTargetItem {
    //1、必须让self.pagerView.mainTableView滚动到headerView刚好消失不见，才能触发列表的滚动
    [self.pagerView.mainTableView setContentOffset:CGPointMake(0, JXTableHeaderViewHeight) animated:NO];
    UITableView *listView = (UITableView *)self.pagerView.validListDict.allValues.firstObject.listScrollView;
    [listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
