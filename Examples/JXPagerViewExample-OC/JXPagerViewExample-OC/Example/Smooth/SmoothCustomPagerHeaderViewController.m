//
//  SmoothCustomPagerHeaderViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "SmoothCustomPagerHeaderViewController.h"
#import "JXPagerSmoothView.h"

@interface SmoothCustomPagerHeaderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *pagerHeader;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation SmoothCustomPagerHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellCount = 20;
    self.cellHeight = 50;
    self.pagerHeader = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.pagerHeader.dataSource = self;
    self.pagerHeader.delegate = self;
    self.pagerHeader.bounces = NO;
    [self.pagerHeader registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"自定义PagerHeader：%ld", indexPath.row];
    return cell;
}

#pragma mark - JXPagerSmoothViewDataSource

- (CGFloat)heightForPagerHeaderInPagerView:(JXPagerSmoothView *)pagerView {
    //高度必须是整个内容的高度，不能让pagerHeader内部能够滚动
    return self.cellCount * self.cellHeight;
}

- (UIView *)viewForPagerHeaderInPagerView:(JXPagerSmoothView *)pagerView {
    return self.pagerHeader;
}

@end
