//
//  FullScreenGestureViewController.m
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2020/4/21.
//  Copyright © 2020 jiaxin. All rights reserved.
//

#import "FullScreenGestureViewController.h"
#import "FullScreenGestureScrollView.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface FullScreenGestureViewController ()

@end

@implementation FullScreenGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (JXPagerView *)preferredPagingView {
    //如果listContainerType是JXPagerListContainerType_ScrollView，需要返回自定义的UIScrollView类
    //如果listContainerType是JXPagerListContainerType_CollectionView，需要返回自定义的UICollectionView类
    return [[JXPagerView alloc] initWithDelegate:self listContainerType:JXPagerListContainerType_ScrollView];
}

- (Class)scrollViewClassInlistContainerViewInPagerView:(JXPagerView *)pagerView {
    return [FullScreenGestureScrollView class];
}


@end
