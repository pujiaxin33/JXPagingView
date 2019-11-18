//
//  SmoothViewController.h
//  JXPagerViewExample-OC
//
//  Created by jiaxin on 2019/11/15.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SmoothListType) {
    SmoothListType_TableView,
    SmoothListType_CollectionView,
    SmoothListType_ScrollView,
};

NS_ASSUME_NONNULL_BEGIN

@interface SmoothViewController : UIViewController
@property (nonatomic, assign) SmoothListType type;
@end

NS_ASSUME_NONNULL_END
