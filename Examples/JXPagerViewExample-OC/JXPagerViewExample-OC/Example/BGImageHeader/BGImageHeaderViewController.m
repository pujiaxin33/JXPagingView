//
//  BGImageHeaderViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/1/2.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "BGImageHeaderViewController.h"

@interface BGImageHeaderViewController ()
@property (nonatomic, strong) UIView *bgMaskView;
@end

@implementation BGImageHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (UIView *subview in self.userHeaderView.subviews) {
        [subview removeFromSuperview];
    }
    self.userHeaderView.backgroundColor = [UIColor clearColor];
    self.categoryView.backgroundColor = [UIColor clearColor];

    UIView *bgView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, JXTableHeaderViewHeight + JXheightForHeaderInSection);
    [bgView addSubview:imageView];

    self.bgMaskView = [[UIView alloc] init];
    self.bgMaskView.backgroundColor = [UIColor whiteColor];
    self.bgMaskView.alpha = 0;
    self.bgMaskView.frame = imageView.frame;
    [bgView addSubview:self.bgMaskView];

    self.pagerView.mainTableView.backgroundView = bgView;
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    double percent = scrollView.contentOffset.y/JXTableHeaderViewHeight;
    self.bgMaskView.alpha = MIN(percent, 1);
}

@end
