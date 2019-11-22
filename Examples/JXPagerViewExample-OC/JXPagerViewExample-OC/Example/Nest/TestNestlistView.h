//
//  TestNestlistView.h
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2018/10/25.
//  Copyright © 2018 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestNestlistView : UIView <JXPagerViewListViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

NS_ASSUME_NONNULL_END
