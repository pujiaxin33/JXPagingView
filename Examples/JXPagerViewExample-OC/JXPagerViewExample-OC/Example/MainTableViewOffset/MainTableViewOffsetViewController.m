//
//  MainTableViewOffsetViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "MainTableViewOffsetViewController.h"

@interface MainTableViewOffsetViewController ()
@property (nonatomic, assign) BOOL isFirstLayout;
@end

@implementation MainTableViewOffsetViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isFirstLayout = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"滚到" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToTargetItem)];
    //在这里设置mainTableView的默认偏移量无效
//    [self.pagerView.mainTableView setContentOffset:CGPointMake(0, 100) animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.isFirstLayout) {
        self.isFirstLayout = NO;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        //mainTableView的默认偏移量设置方法
        self.pagerView.mainTableView.contentOffset = CGPointMake(0, 150);
    }
}

- (void)scrollToTargetItem {
    //必须让self.pagerView.currentScrollingListView滚动到顶部，才能触发main列表的滚动所以这里的animated必须是NO
    [self.pagerView.currentScrollingListView setContentOffset:CGPointZero animated:NO];
    //然后让self.pagerView.mainTableView滚动到顶部，这里的animated可以为YES
    [self.pagerView.mainTableView setContentOffset:CGPointMake(0, 100) animated:NO];
}



@end
