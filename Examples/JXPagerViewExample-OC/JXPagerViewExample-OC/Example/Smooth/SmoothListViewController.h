//
//  SmoothListViewController.h
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerSmoothView.h"
#import "SmoothViewController.h"

@protocol SmoothListViewControllerDelegate <NSObject>

- (CGFloat)pagerHeaderContainerHeight;
- (void)startHeaderRefresh;
- (void)endHeaderRefresh;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SmoothListViewController : UIViewController <JXPagerSmoothViewListViewDelegate>
-(instancetype)initWithType:(SmoothListType)type;
@property (nonatomic, weak) id<SmoothListViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isNeedHeaderRefresh;
@property (nonatomic, assign) BOOL isNeedFooterLoad;
@end

NS_ASSUME_NONNULL_END
