# JXPagingView

[OC版本现已加入豪华套餐，使用方法与swift版本相同](https://github.com/pujiaxin33/JXPagingView/tree/master/JXPagingView-OC)

类似微博主页、简书主页、QQ联系人页面等效果。多页面嵌套，既可以上下滑动，也可以左右滑动切换页面。支持HeaderView悬浮、支持下拉刷新、上拉加载更多。

## 功能特点

- 手势交互更自然；
- 悬浮的categoryView支持更多效果，而且支持自定义扩展；
- 封装性更好，不用关心内部实现，只需要实现对应delegate方法即可；
- 支持像使用普通UITableView一样，添加首页下拉刷新功能；
- 支持列表视图添加下拉刷新、上拉加载更多；

## 预览

### **头图缩放**

![Zoom](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/Zoom.gif)

### **主页下拉刷新&列表上拉加载更多**

![Refresh](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/Refresh.gif)

### **列表下拉刷新**

![Refresh](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/ListRefresh.gif)

### **导航栏隐藏**

![Refresh](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/NaviHidden.gif)

## 头图缩放说明
头图缩放原理，有不明白的可以参考我写的：[JXTableViewZoomHeaderImageView](https://github.com/pujiaxin33/JXTableViewZoomHeaderImageView)  一看就懂了。

## 悬浮HeaderView说明
悬浮的HeaderView，用的是我写的：[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView) 几乎实现了所有主流效果，而且非常容易自定义扩展，强烈推荐阅读。

## 使用

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
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> CGFloat


    /// 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: view
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView


    /// 底部listView的条数
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: count
    func numberOfListViews(in pagingView: JXPagingView) -> Int


    /// 返回对应index的listView，需要是UIView的子类，且要遵循JXPagingViewListViewDelegate。
    /// 这里要求返回一个UIView而不是一个UIScrollView，因为列表的UIScrollView一般是被包装到一个view里面，里面会处理数据源和其他逻辑。
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
    func listScrollView() -> UIScrollView
}
```

4.将外部listView的滚动事件传入View
```
func listViewDidScroll(_ scrollView: UIScrollView) {
     pagingView.listViewDidScroll(scrollView: scrollView)
}
```

OC版本使用类似，查看源码就明白了。


## 补充

有不明白的地方，建议多看下源码。再有疑问的，欢迎提Issue交流🤝


