//
//  SmoothListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "SmoothListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "UIWindow+JXSafeArea.h"

@interface SmoothListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat contentOffsetY;
@end

@implementation SmoothListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //需要在初始化器里面初始化列表视图
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    if (self.isNeedHeaderRefresh) {
        __weak typeof(self)weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.delegate startHeaderRefresh];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.delegate endHeaderRefresh];
            });
        }];
        self.tableView.mj_header.ignoredScrollViewContentInsetTop = [self.delegate pagerHeaderContainerHeight];//pageHeader+pinHeader的高度
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.tableView.frame = self.view.bounds;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%ld", self.title, (long)indexPath.row];
    return cell;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (UIView *)listView {
    return self.view;
}

@end
