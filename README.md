# JXPagingView
类似微博主页、简书主页等效果。既可以上下滑动，也可以左右滑动切换页面。支持HeaderView悬浮、支持下拉刷新、上拉加载更多。

# 预览

**头图缩放**

![Zoom](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/Zoom.gif)

**下拉刷新、上拉加载更多**

![Refresh](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/Refresh.gif)

# 头图缩放说明
头图缩放原理，有不明白的可以参考我写的：[JXTableViewZoomHeaderImageView](https://github.com/pujiaxin33/JXTableViewZoomHeaderImageView)  一看就能懂了。

# HeaderView说明
悬浮的HeaderView，用的是我写的：[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView) 几乎实现了所有主流效果，而且非常容易自定义扩展，强烈推荐阅读。

# 使用

1.实例化`JXPagingView`
```swift
        pagingView = JXPagingView(delegate: self)
        pagingView.delegate = self
        self.view.addSubview(pagingView)
```

2.实现`JXPagingViewDelegate`
```swift
@objc public protocol JXPagingViewDelegate: NSObjectProtocol {


    /// tableHeaderView的高度
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: height
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> CGFloat


    /// 返回tableHeaderView
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: view
    func tableHeaderView(in pagingView: JXPagingView) -> UIView


    /// 返回悬浮HeaderView的高度。
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: height
    func heightForHeaderInSection(in pagingView: JXPagingView) -> CGFloat


    /// 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: view
    func viewForHeaderInSection(in pagingView: JXPagingView) -> UIView


    /// 底部listView的条数
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: count
    func numberOfListViews(in pagingView: JXPagingView) -> Int


    /// 返回对应index的listView，需要是UIView的子类，且要遵循JXPagingViewListViewDelegate。
    /// 这里要求返回一个UIView而不是一个UIScrollView，因为listView可能并不只是一个单纯的UITableView或UICollectionView，可能还会有其他的子视图。
    ///
    /// - Parameters:
    ///   - pagingView: JXPagingViewView
    ///   - row: row
    /// - Returns: view
    func pagingView(_ pagingView: JXPagingView, listViewInRow row: Int) -> JXPagingViewListViewDelegate & UIView


    /// mainTableView的滚动回调，用于实现头图跟随缩放
    ///
    /// - Parameter scrollView: JXPagingViewMainTableView
    @objc optional func mainTableViewDidScroll(_ scrollView: UIScrollView)
}
```

3.让外部listView遵从`JXPagingViewListViewDelegate`协议
```swift
//该协议主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
@objc public protocol JXPagingViewListViewDelegate: NSObjectProtocol {
    var scrollView: UIScrollView { get }
}
```

4.将外部listView的滚动事件传入userProfileView
```
func listViewDidScroll(_ scrollView: UIScrollView) {
     pagingView.listViewDidScroll(scrollView: scrollView)
}
```


