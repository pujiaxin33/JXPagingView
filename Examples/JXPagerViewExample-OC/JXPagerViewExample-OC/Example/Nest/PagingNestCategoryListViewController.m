//
//  PagingNestCategoryListViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "PagingNestCategoryListViewController.h"
#import "TestNestListBaseView.h"
#import "JXCategoryTitleView.h"

@interface PagingNestCategoryListViewController () <JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) TestNestListBaseView *powerListView;
@property (nonatomic, strong) TestNestListBaseView *hobbyListView;
@property (nonatomic, strong) TestNestListBaseView *partnerListView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIScrollView *currentListView;
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

    __weak typeof(self) weakSelf = self;
    self.powerListView = [[TestNestListBaseView alloc] init];
    self.powerListView.scrollCallback = ^(UIScrollView *scrollView) {
        weakSelf.scrollCallback(scrollView);
    };
    self.powerListView.dataSource = @[@"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮", @"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮"].mutableCopy;

    self.currentListView = self.powerListView.tableView;

    self.hobbyListView = [[TestNestListBaseView alloc] init];
    self.hobbyListView.scrollCallback = ^(UIScrollView *scrollView) {
        weakSelf.scrollCallback(scrollView);
    };
    self.hobbyListView.dataSource = @[@"吃烤肉", @"吃鸡腿肉", @"吃牛肉", @"各种肉"].mutableCopy;

    self.partnerListView = [[TestNestListBaseView alloc] init];
    self.partnerListView.scrollCallback = ^(UIScrollView *scrollView) {
        weakSelf.scrollCallback(scrollView);
    };
    self.partnerListView.dataSource = @[@"【剑士】罗罗诺亚·索隆", @"【航海士】娜美", @"【狙击手】乌索普", @"【厨师】香吉士", @"【船医】托尼托尼·乔巴", @"【船匠】 弗兰奇", @"【音乐家】布鲁克", @"【考古学家】妮可·罗宾"].mutableCopy;

    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.pagingEnabled = YES;
    [self.contentScrollView addSubview:self.powerListView];
    [self.contentScrollView addSubview:self.hobbyListView];
    [self.contentScrollView addSubview:self.partnerListView];
    [self.view addSubview:self.contentScrollView];

    self.categoryView.contentScrollView = self.contentScrollView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    self.contentScrollView.frame = CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width*3, self.contentScrollView.bounds.size.height);
    self.powerListView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.contentScrollView.bounds.size.height);
    self.hobbyListView.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.contentScrollView.bounds.size.height);
    self.partnerListView.frame = CGRectMake(self.view.bounds.size.width*2, 0, self.view.bounds.size.width, self.contentScrollView.bounds.size.height);
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
    //当前的listScrollView需要重置的时候，就把三个列表都重置了
    self.powerListView.tableView.contentOffset = CGPointZero;
    self.hobbyListView.tableView.contentOffset = CGPointZero;
    self.partnerListView.tableView.contentOffset = CGPointZero;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //根据选中的下标，实时更新currentListView
    switch (index) {
        case 0:
            self.currentListView = self.powerListView.tableView;
            break;
        case 1:
            self.currentListView = self.hobbyListView.tableView;
            break;
        case 2:
            self.currentListView = self.partnerListView.tableView;
            break;
        default:
            break;
    }
}

@end
