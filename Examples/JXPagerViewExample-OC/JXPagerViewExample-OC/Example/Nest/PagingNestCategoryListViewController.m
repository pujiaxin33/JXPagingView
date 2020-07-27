//
//  PagingNestCategoryListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "PagingNestCategoryListViewController.h"
#import "TestNestListBaseView.h"
#import <JXCategoryView/JXCategoryView.h>

@interface PagingNestCategoryListViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIScrollView *currentListView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@end

@implementation PagingNestCategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.backgroundColor = [UIColor cyanColor];
    self.categoryView.titles = @[@"子题一", @"子题二", @"子题三"];
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];

    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    [self.view addSubview:self.listContainerView];
    self.contentScrollView = self.listContainerView.scrollView;

    self.categoryView.listContainer = self.listContainerView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    self.listContainerView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
}

#pragma  mark - JXPagerViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.currentListView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listScrollViewWillResetContentOffset {
    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
    for (TestNestListBaseView *list in self.listContainerView.validListDict.allValues) {
        list.tableView.contentOffset = CGPointZero;
    }
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //根据选中的下标，实时更新currentListView
    TestNestListBaseView *list = (TestNestListBaseView *)self.listContainerView.validListDict[@(index)];
    self.currentListView = list.tableView;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    if (index == 0) {
        TestNestListBaseView *powerListView = [[TestNestListBaseView alloc] init];
        powerListView.scrollCallback = ^(UIScrollView *scrollView) {
            weakSelf.scrollCallback(scrollView);
        };
        powerListView.dataSource = @[@"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮", @"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮"].mutableCopy;
        self.currentListView = powerListView.tableView;
        return powerListView;
    }else if (index == 1) {
        TestNestListBaseView *hobbyListView = [[TestNestListBaseView alloc] init];
        hobbyListView.scrollCallback = ^(UIScrollView *scrollView) {
            weakSelf.scrollCallback(scrollView);
        };
        hobbyListView.dataSource = @[@"吃烤肉", @"吃鸡腿肉", @"吃牛肉", @"各种肉"].mutableCopy;
        self.currentListView = hobbyListView.tableView;
        return hobbyListView;
    }else {
        TestNestListBaseView *partnerListView = [[TestNestListBaseView alloc] init];
        partnerListView.scrollCallback = ^(UIScrollView *scrollView) {
            weakSelf.scrollCallback(scrollView);
        };
        partnerListView.dataSource = @[@"【剑士】罗罗诺亚·索隆", @"【航海士】娜美", @"【狙击手】乌索普", @"【厨师】香吉士", @"【船医】托尼托尼·乔巴", @"【船匠】 弗兰奇", @"【音乐家】布鲁克", @"【考古学家】妮可·罗宾"].mutableCopy;
        self.currentListView = partnerListView.tableView;
        return partnerListView;
    }
}

@end
