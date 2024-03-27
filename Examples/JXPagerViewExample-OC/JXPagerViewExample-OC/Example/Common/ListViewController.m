//
//  ListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "UIWindow+JXSafeArea.h"

#import <WebKit/WebKit.h>

@interface ListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ListViewController

- (void)dealloc {
    NSLog(@"ListViewController dealloced");
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.tableView.tableFooterView = [UIView new];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    //列表的contentInsetAdjustmentBehavior失效，需要自己设置底部inset
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, UIApplication.sharedApplication.keyWindow.jx_layoutInsets.bottom, 0);
//    [self.view addSubview:self.tableView];
//
//    __weak typeof(self)weakSelf = self;
//    if (self.isNeedHeader) {
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.tableView.mj_header endRefreshing];
//            });
//        }];
//    }
//    if (self.isNeedFooter) {
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.dataSource addObject:@"加载更多成功"];
//                [weakSelf.tableView reloadData];
//                [weakSelf.tableView.mj_footer endRefreshing];
//            });
//        }];
//    }
//
//    [self beginFirstRefresh];
    
    
#warning 调试 WKWebView 滚动导致头视图置顶
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.webView loadRequest:request];
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//
//    self.tableView.frame = self.view.bounds;
//}

- (void)beginFirstRefresh {
    if (!self.isHeaderRefreshed) {
        [self beginRefreshImmediately];
    }
}

- (void)beginRefreshImmediately {
//    if (self.isNeedHeader) {
//        [self.tableView.mj_header beginRefreshing];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.isHeaderRefreshed = YES;
//            [self.tableView reloadData];
//            [self.tableView.mj_header endRefreshing];
//        });
//    }else {
//        self.isHeaderRefreshed = YES;
//        [self.tableView reloadData];
//    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (!self.isHeaderRefreshed) {
//        return 0;
//    }
//    return self.dataSource.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.textLabel.text = self.dataSource[indexPath.row];
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DetailViewController *detailVC = [[DetailViewController alloc] init];
//    detailVC.infoString = self.dataSource[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
//    return self.tableView;
    return self.webView.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listWillDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

@end
