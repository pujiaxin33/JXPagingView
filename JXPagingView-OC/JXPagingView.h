//
//  JXPagingView.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagingMainTableView.h"
#import "JXPagingListContainerView.h"

@class JXPagingView;

/**
 该协议主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
 */
@protocol JXPagingViewListViewDelegate <NSObject>


/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView;


/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback;

@end

@protocol JXPagingViewDelegate <NSObject>


/**
 返回tableHeaderView的高度

 @param pagingView pagingView description
 @return return tableHeaderView的高度
 */
- (CGFloat)tableHeaderViewHeightInPagingView:(JXPagingView *)pagingView;


/**
 返回tableHeaderView

 @param pagingView pagingView description
 @return tableHeaderView
 */
- (UIView *)tableHeaderViewInPagingView:(JXPagingView *)pagingView;


/**
 返回悬浮HeaderView的高度。

 @param pagingView pagingView description
 @return 悬浮HeaderView的高度
 */
- (CGFloat)heightForPinSectionHeaderInPagingView:(JXPagingView *)pagingView;


/**
 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写

 @param pagingView pagingView description
 @return 悬浮HeaderView
 */
- (UIView *)viewForPinSectionHeaderInPagingView:(JXPagingView *)pagingView;

/**
 返回listViews，数组的item需要是UIView的子类，且要遵循JXPagingViewListViewDelegate。
 数组item要求返回一个UIView而不是一个UIScrollView，因为列表的UIScrollView一般是被包装到一个view里面，里面会处理数据源和其他逻辑。

 @param pagingView pagingView description
 @return listViews
 */
- (NSArray <UIView <JXPagingViewListViewDelegate>*>*)listViewsInPagingView:(JXPagingView *)pagingView;

@optional

/**
 mainTableView的滚动回调，用于实现头图跟随缩放

 @param scrollView mainTableView
 */
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface JXPagingView : UIView

@property (nonatomic, weak) id<JXPagingViewDelegate> delegate;

@property (nonatomic, strong, readonly) JXPagingMainTableView *mainTableView;

@property (nonatomic, strong, readonly) JXPagingListContainerView *listContainerView;

- (instancetype)initWithDelegate:(id<JXPagingViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) UIScrollView *currentScrollingListView;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData;

#pragma mark - Subclass

- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView;

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView;

@end


