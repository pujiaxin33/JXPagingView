//
//  SmoothCustomPagerHeaderViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "SmoothCustomPagerHeaderViewController.h"
#import "JXPagerSmoothView.h"
#import "SmoothListViewController.h"

@interface SmoothCustomPagerHeaderViewController () <UITableViewDataSource, UITableViewDelegate, SmoothListViewControllerDelegate>
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
    self.pagerHeader.scrollsToTop = NO;
    [self.pagerHeader registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStylePlain target:self action:@selector(reloadData)];
}

- (void)reloadData {
    [self.pager reloadData];
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

- (id<JXPagerSmoothViewListViewDelegate>)pagerView:(JXPagerSmoothView *)pagerView initListAtIndex:(NSInteger)index {
    SmoothListViewController *listVC = [[SmoothListViewController alloc] initWithType:SmoothListType_TableView];
    listVC.isNeedHeaderRefresh = YES;
    listVC.isNeedFooterLoad = YES;
    listVC.delegate = self;
    listVC.title = self.categoryView.titles[index];
    return listVC;
}

#pragma mark - SmoothListViewControllerDelegate

- (void)startHeaderRefresh {
    //正在刷新的时候，需要暂时不允许用户交互。
    self.pager.listCollectionView.scrollEnabled = NO;
    self.categoryView.userInteractionEnabled = NO;
}

- (void)endHeaderRefresh {
    self.pager.listCollectionView.scrollEnabled = YES;
    self.categoryView.userInteractionEnabled = YES;
}

- (CGFloat)pagerHeaderContainerHeight {
    return self.cellCount * self.cellHeight + 50;
}

@end
