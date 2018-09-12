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
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            RefreshViewController *vc = [[RefreshViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            ListRefreshViewController *vc = [[ListRefreshViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            NaviBarHiddenViewController *vc = [[NaviBarHiddenViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

//override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let cell = tableView.cellForRow(at: indexPath)
//    var title: String?
//    for view in cell!.contentView.subviews {
//        if view.isKind(of: UILabel.classForCoder()) {
//            let label = view as! UILabel
//            title = label.text
//            break
//        }
//    }
//    switch indexPath.row {
//    case 0:
//        let vc = ZoomViewController()
//        vc.title = title
//        self.navigationController?.pushViewController(vc, animated: true)
//    case 1:
//        let vc = RefreshViewController()
//        vc.title = title
//        self.navigationController?.pushViewController(vc, animated: true)
//    case 2:
//        let vc = ListRefreshViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    case 3:
//        let vc = NaviHiddenViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    default:
//        break
//    }
//}

@end
