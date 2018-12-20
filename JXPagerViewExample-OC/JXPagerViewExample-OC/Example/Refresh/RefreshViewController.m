//
//  RefreshViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "RefreshViewController.h"
#import "MJRefresh.h"

@interface RefreshViewController ()
@property (nonatomic, assign) BOOL isHeaderRefreshed;
@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isNeedFooter = YES;

    __weak typeof(self)weakSelf = self;
    self.pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isHeaderRefreshed = YES;
            self.categoryView.titles = @[@"高级能力", @"高级爱好", @"高级队友"];
            self.categoryView.defaultSelectedIndex = 0;
            [self.categoryView reloadData];
            [self.pagerView reloadData];
            [weakSelf.pagerView.mainTableView.mj_header endRefreshing];
        });
    }];
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if (!self.isHeaderRefreshed) {
        return [super pagerView:pagerView initListAtIndex:index];
    }
    TestListBaseView *listView = [[TestListBaseView alloc] init];
    listView.isNeedHeader = self.isNeedHeader;
    listView.isNeedFooter = self.isNeedFooter;
    if (index == 0) {
        listView.dataSource = @[@"高级-橡胶火箭", @"高级-橡胶火箭炮", @"高级-橡胶机关枪", @"高级-橡胶子弹", @"高级-橡胶攻城炮", @"高级-橡胶象枪", @"高级-橡胶象枪乱打", @"高级-橡胶灰熊铳", @"高级-橡胶雷神象枪", @"高级-橡胶猿王枪", @"高级-橡胶犀·榴弹炮", @"高级-橡胶大蛇炮", @"高级-橡胶火箭", @"高级-橡胶火箭炮", @"高级-橡胶机关枪", @"高级-橡胶子弹", @"高级-橡胶攻城炮", @"高级-橡胶象枪", @"高级-橡胶象枪乱打", @"高级-橡胶灰熊铳", @"高级-橡胶雷神象枪", @"高级-橡胶猿王枪", @"高级-橡胶犀·榴弹炮", @"高级-橡胶大蛇炮"].mutableCopy;
    }else if (index == 1) {
        listView.dataSource = @[@"高级-吃烤肉", @"高级-吃鸡腿肉", @"高级-吃牛肉", @"高级-各种肉"].mutableCopy;
    }else {
        listView.dataSource = @[@"高级-【剑士】罗罗诺亚·索隆", @"高级-【航海士】娜美", @"高级-【狙击手】乌索普", @"高级-【厨师】香吉士", @"高级-【船医】托尼托尼·乔巴", @"高级-【船匠】 弗兰奇", @"高级-【音乐家】布鲁克", @"高级-【考古学家】妮可·罗宾"].mutableCopy;
    }
    [listView beginFirstRefresh];
    self.validListViewDict[@(index)] = listView;
    return listView;
}


@end
