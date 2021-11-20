//
//  SmoothViewController.h
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/15.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerSmoothView.h"
#import "JXCategoryTitleView.h"

typedef NS_ENUM(NSUInteger, SmoothListType) {
    SmoothListType_TableView,
    SmoothListType_CollectionView,
    SmoothListType_ScrollView,
    SmoothListType_InputHeader,
};

NS_ASSUME_NONNULL_BEGIN

@interface SmoothViewController : UIViewController

@property (nonatomic, strong) JXPagerSmoothView *pager;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, assign) SmoothListType type;

@end

NS_ASSUME_NONNULL_END
