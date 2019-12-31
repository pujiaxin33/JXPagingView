//
//  PagingNestCategoryListViewController.h
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN

@interface PagingNestCategoryListViewController : UIViewController <JXPagerViewListViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

NS_ASSUME_NONNULL_END
