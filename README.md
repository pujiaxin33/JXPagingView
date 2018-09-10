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

| 效果  | 预览图 |
|-------|-------|
| **头图缩放** | ![Zoom](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/Zoom.gif) | 
| **主页下拉刷新&列表上拉加载更多** | ![Refresh](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/Refresh.gif) |
| **列表下拉刷新** | ![Refresh](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/ListRefresh.gif) |
| **导航栏隐藏** | ![Refresh](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/NaviHidden.gif) |

## 头图缩放说明
头图缩放原理，有不明白的可以参考我写的：[JXTableViewZoomHeaderImageView](https://github.com/pujiaxin33/JXTableViewZoomHeaderImageView)  一看就懂了。

## 悬浮HeaderView说明
悬浮的HeaderView，用的是我写的：[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView) 几乎实现了所有主流效果，而且非常容易自定义扩展，强烈推荐阅读。

## 列表下拉刷新说明

需要使用`JXPagingListRefreshView`类（是`JXPagingView`的子类）

## 安装

### 手动

**Swift版本：** Clone代码，拖入JXPagingView-Swift文件夹，使用`JXPagingView`类；

**OC版本：** Clone代码，拖入JXPagerView文件夹，使用`JXPagerView`类；

### CocoaPods

- **Swift版本**
```ruby
target '<Your Target Name>' do
    pod 'JXPagingView/Paging'
end
```

- **OC版本**
```ruby
target '<Your Target Name>' do
    pod 'JXPagingView/Pager'
end
```

Swift与OC的仓库地址不一样，请注意选择！

`pod install`之前最好`pod repo udpate`一下！


## 使用

主要遵从`JXPagingViewDelegate`和`JXPagingViewListViewDelegate`协议就可以实现了，逻辑非常简单明了。具体实现细节请查阅源码。

1.实例化`JXPagingView`
```swift
    let pagingView = JXPagingView(delegate: self)
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

    /// 返回listViews，数组的item需要是UIView的子类，且要遵循JXPagingViewListViewDelegate。
    /// 数组item要求返回一个UIView而不是一个UIScrollView，因为列表的UIScrollView一般是被包装到一个view里面，里面会处理数据源和其他逻辑。
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: listViews
    func listViews(in pagingView: JXPagingView) -> [JXPagingViewListViewDelegate & UIView]

    /// mainTableView的滚动回调，用于实现头图跟随缩放
    ///
    /// - Parameter scrollView: JXPagingViewMainTableView
    @objc optional func mainTableViewDidScroll(_ scrollView: UIScrollView)
}
```

3.让底部listView遵从`JXPagingViewListViewDelegate`协议
```swift
/// 返回listView内部持有的UIScrollView或UITableView或UICollectionView
/// 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
@objc public protocol JXPagingViewListViewDelegate: NSObjectProtocol {
    func listScrollView() -> UIScrollView
}

///当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
    self.listViewDidScrollCallback = callback
}

//self.listViewDidScrollCallback在listView的scrollViewDidScroll代理方法里面回调
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.listViewDidScrollCallback?(scrollView)
}
```

OC版本使用类似，只是类名及相关API更改为`JXPagerView`，具体细节请查看源码。

## 关于下方列表视图的代理方法`func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)`有时候需要点击两次才回调

出现步骤：当手指放在下方列表视图往下拉，直到TableHeaderView完全显示。

原因：经过上面的步骤之后，手指已经离开屏幕且列表视图已经完全静止，UIScrollView的isDragging属性却依然是true。就导致了后续的第一次点击，让系统认为当前UIScrollView依然在滚动，该点击就让UIScrollView停止下来，没有继续转发给UITableView，就没有转化成didSelectRow事件。

解决方案：经过N种尝试之后，还是没有回避掉系统的`isDragging`异常为true的bug。大家可以在自定义cell最下方放置一个与cell同大小的button，把button的touchUpInside事件当做`didSelectRow`的回调。因为UIButton在响应链中的优先级要高于UIGestureRecognizer。

代码：请参考`TestTableViewCell`类的配置。


## 补充

有不明白的地方，建议多看下源码。再有疑问的，欢迎提Issue交流🤝


