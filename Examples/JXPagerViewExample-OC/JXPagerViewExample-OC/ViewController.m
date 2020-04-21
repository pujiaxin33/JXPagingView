//
//  ViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/9/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ViewController.h"
#import "ZoomViewController.h"
#import "RefreshViewController.h"
#import "ListRefreshViewController.h"
#import "NaviBarHiddenViewController.h"
#import "PagingNestCategoryViewController.h"
#import "BannerViewController.h"
#import "HeaderPositionViewController.h"
#import "ReloadWithoutInitListViewController.h"
#import "ScrollToTopViewController.h"
#import "ScrollToListCellViewController.h"
#import "SmoothViewController.h"
#import "SmoothCustomPagerHeaderViewController.h"
#import "MainTableViewOffsetViewController.h"
#import "BGImageHeaderViewController.h"
#import "HeaderPositionChangeViewController.h"
#import "CustomPinViewViewController.h"
#import "TabBarExampleViewController.h"
#import "CustomCategoryViewController.h"
#import "FullScreenGestureViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = nil;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            title = [(UILabel *)view text];
            break;
        }
    }
    switch (indexPath.row) {
        case 0:
        {
            ZoomViewController *vc = [[ZoomViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            RefreshViewController *vc = [[RefreshViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ListRefreshViewController *vc = [[ListRefreshViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            NaviBarHiddenViewController *vc = [[NaviBarHiddenViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            PagingNestCategoryViewController *vc = [[PagingNestCategoryViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            BannerViewController *vc = [[BannerViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            HeaderPositionViewController *vc = [[HeaderPositionViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:
        {
            ReloadWithoutInitListViewController *vc = [[ReloadWithoutInitListViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:
        {
            ScrollToTopViewController *vc = [[ScrollToTopViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:
        {
            ScrollToListCellViewController *vc = [[ScrollToListCellViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:
        {
            SmoothViewController *vc = [[SmoothViewController alloc] init];
            vc.title = title;
            vc.type = SmoothListType_TableView;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            SmoothViewController *vc = [[SmoothViewController alloc] init];
            vc.title = title;
            vc.type = SmoothListType_CollectionView;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 12:
        {
            SmoothViewController *vc = [[SmoothViewController alloc] init];
            vc.title = title;
            vc.type = SmoothListType_ScrollView;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 13:
        {
            SmoothCustomPagerHeaderViewController *vc = [[SmoothCustomPagerHeaderViewController alloc] init];
            vc.title = title;
            vc.type = SmoothListType_TableView;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 14:
        {
            MainTableViewOffsetViewController *vc = [[MainTableViewOffsetViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 15:
        {
            BGImageHeaderViewController *vc = [[BGImageHeaderViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 16:
        {
            HeaderPositionChangeViewController *vc = [[HeaderPositionChangeViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 17:
        {
            CustomPinViewViewController *vc = [[CustomPinViewViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 18:
        {
            TabBarExampleViewController *vc = [[TabBarExampleViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 19:
        {
            CustomCategoryViewController *vc = [[CustomCategoryViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 20:
        {
            FullScreenGestureViewController *vc = [[FullScreenGestureViewController alloc] init];
            vc.title = title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }
}

@end
