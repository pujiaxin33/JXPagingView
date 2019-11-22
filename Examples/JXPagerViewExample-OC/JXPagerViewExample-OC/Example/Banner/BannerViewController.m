//
//  BannerViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/2/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "BannerViewController.h"
#import "PagingViewBannerTableHeaderView.h"

@interface BannerViewController ()
@property (nonatomic, strong) PagingViewBannerTableHeaderView *bannerView;
@end

@implementation BannerViewController

- (void)viewDidLoad {
    _bannerView = [[PagingViewBannerTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.bannerView;
}

//self.pagerView.mainTableView.gestureDelegate = self; 成为mainTableView的手势代理
//当otherGestureRecognizer时轮播视图collectionView.panGestureRecognizer返回NO，即可
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //禁止banner左右滑动的时候，上下和左右都可以滚动
    if (otherGestureRecognizer == self.bannerView.collectionView.panGestureRecognizer) {
        return NO;
    }
    return [super mainTableViewGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

@end
