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
#import "NestViewController.h"
#import "BannerViewController.h"
#import "HeaderPositionViewController.h"
#import "ReloadWithoutInitListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
            NestViewController *vc = [[NestViewController alloc] init];
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
        default:
            break;
    }
}

@end
