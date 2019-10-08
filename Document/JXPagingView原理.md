# JXPagingView原理

## 视图层级

![structure](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXPaingView/JXPagingView%20Structure.png)

## 主列表与子列表的垂直滚动交互

`JXPagerMainTableView`实现了代理方法`- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer`，当两个`gestureRecognizer`都是`UIPanGestureRecognizer`时，即是主列表滚动手势和子列表滚动手势时，让两个手势同时响应。这时，滚动子列表时就会同步让主列表滚动。

为了实现子列表从下滚动到上面，并且让分类选择器视图悬浮到顶部，就需要在主列表和子列表的`scrollViewDidScroll`代理方法做特殊处理。

### 主列表`scrollViewDidScroll`滚动处理

- mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
- mainTableView已经显示了header，listView的contentOffset需要重置

### 子列表`scrollViewDidScroll`滚动处理

- mainTableView的header还没有消失，让listScrollView一直为0
- mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条，子列表继续滚动

## 子列表的左右滚动交互

子列表都是被添加到`JXPagerListContainerView`的`collectionView`的cell上面的，当`collectionView`左右滚动的时候，会禁止主列表的滚动`self.mainTableView.scrollEnabled = NO;`。这样子就实现了，左右滚动时，无法上下滚动。


