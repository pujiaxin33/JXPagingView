//
//  TabBarExampleViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/1/11.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "TabBarExampleViewController.h"
#import "PagingViewController.h"

@interface TabBarExampleViewController ()

@end

@implementation TabBarExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *list = [NSMutableArray array];
    for (int index = 1; index <= 3; index++) {
        PagingViewController *vc = [[PagingViewController alloc] init];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithFormat:@"第%d页", index] image:nil selectedImage:nil];
        [list addObject:vc];
    }
    self.viewControllers = list;
}


@end
