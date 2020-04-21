//
//  ReloadWithoutInitListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/6/13.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "ReloadWithoutInitListViewController.h"
#import "ListViewController.h"

@interface ReloadWithoutInitListViewController ()
@property (nonatomic, strong) NSMutableDictionary <NSString *, id<JXPagerViewListViewDelegate>> *listCache;
@end

@implementation ReloadWithoutInitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _listCache = [NSMutableDictionary dictionary];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStylePlain target:self action:@selector(reloadWithoutInitList)];
}

- (void)reloadWithoutInitList {
    //第一种：titles更新之后的reload
    self.categoryView.titles = @[@"爱好", @"队友", @"其他"];
    //titles有删除的情况，需要清空对应的list缓存
    [self.listCache removeObjectForKey:@"能力"];
    [self.categoryView reloadDataWithoutListContainer];
    [self.pagerView reloadData];
    /*
    //第二种：pinSectionHeaderVerticalOffset更新之后的reload
    self.pagerView.pinSectionHeaderVerticalOffset = 50;
    [self.pagerView reloadData];
     */
    //其他情况以此类推
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    id<JXPagerViewListViewDelegate> listInCache = self.listCache[self.categoryView.titles[index]];
    if (listInCache != nil) {
        return listInCache;
    }else {
        ListViewController *listView = [[ListViewController alloc] init];
        listView.title = self.categoryView.titles[index];
        listView.isNeedHeader = YES;
        if (index == 0) {
            listView.dataSource = @[@"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮", @"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮"].mutableCopy;
        }else if (index == 1) {
            listView.dataSource = @[@"吃烤肉", @"吃鸡腿肉", @"吃牛肉", @"各种肉"].mutableCopy;
        }else {
            listView.dataSource = @[@"【剑士】罗罗诺亚·索隆", @"【航海士】娜美", @"【狙击手】乌索普", @"【厨师】香吉士", @"【船医】托尼托尼·乔巴", @"【船匠】 弗兰奇", @"【音乐家】布鲁克", @"【考古学家】妮可·罗宾"].mutableCopy;
        }
        //将初始化之后的列表缓存起来
        self.listCache[self.categoryView.titles[index]] = listView;
        return listView;
    }
}

@end
