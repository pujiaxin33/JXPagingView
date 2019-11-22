//
//  TestNestListBaseView.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/10/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

#import "TestNestListBaseView.h"
#import "MJRefresh.h"
#import "TestTableViewCell.h"
#import "JXCategoryTitleView.h"

@interface TestNestListBaseView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@end

@implementation TestNestListBaseView

- (void)dealloc
{
    self.scrollCallback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, frame.size.width, frame.size.height - 50) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[TestTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];

        __weak typeof(self) weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
        }];

        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.dataSource addObject:@"加载更多成功"];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
            });
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.tableView.frame = self.bounds;
}

- (void)selectCellAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastSelectedIndexPath == indexPath) {
        return;
    }
    if (self.lastSelectedIndexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.lastSelectedIndexPath];
        [cell setSelected:NO animated:NO];
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:NO];
    self.lastSelectedIndexPath = indexPath;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    __weak typeof(self)weakSelf = self;
    cell.bgButtonClicked = ^{
        [weakSelf selectCellAtIndexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

@end
