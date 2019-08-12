//
//  JXPagingView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

@objc public protocol JXPagingViewListViewDelegate: NSObjectProtocol {

    /// 返回listView
    ///
    /// - Returns: UIView
    func listView() -> UIView

    /// 返回listView内部持有的UIScrollView或UITableView或UICollectionView
    /// 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
    ///
    /// - Returns: listView内部持有的UIScrollView或UITableView或UICollectionView
    func listScrollView() -> UIScrollView


    /// 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
    ///
    /// - Parameter callback: `scrollViewDidScroll`回调时调用的callback
    func listViewDidScrollCallback(callback: @escaping (UIScrollView)->())

    /// 将要重置listScrollView的contentOffset
    @objc optional func listScrollViewWillResetContentOffset()

    /// 列表显示的时候调用
    @objc optional func listDidAppear()

    /// 列表消失的时候调用
    @objc optional func listDidDisappear()
}

@objc public protocol JXPagingViewDelegate: NSObjectProtocol {


    /// tableHeaderView的高度，因为内部需要比对判断，只能是整型数
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: height
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int


    /// 返回tableHeaderView
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: view
    func tableHeaderView(in pagingView: JXPagingView) -> UIView


    /// 返回悬浮HeaderView的高度，因为内部需要比对判断，只能是整型数
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: height
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int


    /// 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: view
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView

    /// 返回列表的数量
    ///
    /// - Parameter pagingView: pagingView description
    /// - Returns: 列表的数量
    func numberOfLists(in pagingView: JXPagingView) -> Int

    /// 根据index初始化一个对应列表实例，需要是遵从`JXPagerViewListViewDelegate`协议的对象。
    /// 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIView即可。
    /// 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagerViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
    /// 注意：一定要是新生成的实例！！！
    ///
    /// - Parameters:
    ///   - pagingView: pagingView description
    ///   - index: 新生成的列表实例
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate

    /// mainTableView的滚动回调，用于实现头图跟随缩放
    ///
    /// - Parameter scrollView: JXPagingViewMainTableView
    @objc optional func mainTableViewDidScroll(_ scrollView: UIScrollView)
}

open class JXPagingView: UIView {
    /// 需要和self.categoryView.defaultSelectedIndex保持一致
    open var defaultSelectedIndex: Int = 0 {
        didSet {
            listContainerView.defaultSelectedIndex = defaultSelectedIndex
        }
    }
    open var mainTableView: JXPagingMainTableView!
    open var listContainerView: JXPagingListContainerView!
    /// 当前已经加载过可用的列表字典，key就是index值，value是对应的列表。
    public var validListDict = [Int:JXPagingViewListViewDelegate]()
    /// 顶部固定sectionHeader的垂直偏移量。数值越大越往下沉。
    open var pinSectionHeaderVerticalOffset: Int = 0
    public var isListHorizontalScrollEnabled = true {
        didSet {
            refreshListHorizontalScrollEnabledState()
        }
    }
    /// 是否支持设备旋转
    open var isDeviceOrientationChangeEnabled = false
    /// 是否允许当前列表自动显示或隐藏列表是垂直滚动指示器。true：悬浮的headerView滚动到顶部开始滚动列表时，就会显示，反之隐藏。false：内部不会处理列表的垂直滚动指示器。默认为：true。
    open var automaticallyDisplayListVerticalScrollIndicator = true
    public var currentScrollingListView: UIScrollView?
    public var currentList: JXPagingViewListViewDelegate?
    private weak var delegate: JXPagingViewDelegate?
    private var currentDeviceOrientation: UIDeviceOrientation?
    private var currentIndex: Int = 0
    private var retainedSelf: JXPagingView?
    private var isWillRemoveFromWindow: Bool = false
    private var isFirstMoveToWindow: Bool = true
    private var tableHeaderContainerView: UIView?

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    public init(delegate: JXPagingViewDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)

        initializeViews()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func initializeViews(){
        mainTableView = JXPagingMainTableView(frame: CGRect.zero, style: .plain)
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.separatorStyle = .none
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.scrollsToTop = false
        refreshTableHeaderView()
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        addSubview(mainTableView)

        if #available(iOS 11.0, *) {
            mainTableView.contentInsetAdjustmentBehavior = .never
        } 

        listContainerView = JXPagingListContainerView(delegate: self)
        listContainerView.mainTableView = mainTableView

        refreshListHorizontalScrollEnabledState()

        self.currentDeviceOrientation = UIDevice.current.orientation
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(notification:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    open override func willMove(toWindow newWindow: UIWindow?) {
        if self.isFirstMoveToWindow {
            //第一次调用过滤，因为第一次列表显示通知会从willDisplayCell方法通知
            self.isFirstMoveToWindow = false
            return
        }
        //当前页面push到一个新的页面时，willMoveToWindow会调用三次。第一次调用的newWindow为nil，第二次调用间隔1ms左右newWindow有值，第三次调用间隔400ms左右newWindow为nil。
        //根据上述事实，第一次和第二次为无效调用，可以根据其间隔1ms左右过滤掉
        if newWindow == nil {
            self.isWillRemoveFromWindow = true
            //当前页面被pop的时候，willMoveToWindow只会调用一次，而且整个页面会被销毁掉，所以需要循环引用自己，确保能延迟执行currentListDidDisappear方法，触发列表消失事件。由此可见，循环引用也不一定是个坏事。是天使还是魔鬼，就看你如何对待它了。
            self.retainedSelf = self
            self.perform(#selector(currentListDidDisappear), with: nil, afterDelay: 0.02)
        }else {
            if self.isWillRemoveFromWindow {
                self.isWillRemoveFromWindow = false
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(currentListDidDisappear), object: nil)
            }else {
                self.currentListDidAppear()
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        mainTableView.frame = self.bounds
    }

    open func reloadData() {
        self.currentList = nil
        self.currentScrollingListView = nil

        for list in validListDict.values {
            list.listView().removeFromSuperview()
        }
        validListDict.removeAll()

        refreshTableHeaderView()
        self.mainTableView.reloadData()
        self.listContainerView.reloadData()
    }

    open func resizeTableHeaderViewHeight(animatable: Bool = false, duration: TimeInterval = 0.25, curve: UIView.AnimationCurve = .linear) {
        if animatable {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(duration)
            UIView.setAnimationCurve(curve)
            var bounds = tableHeaderContainerView?.bounds
            bounds?.size.height = CGFloat(self.delegate!.tableHeaderViewHeight(in: self))
            tableHeaderContainerView?.frame = bounds!
            mainTableView.tableHeaderView = tableHeaderContainerView
            UIView.commitAnimations()
        }else {
            var bounds = tableHeaderContainerView?.bounds
            bounds?.size.height = CGFloat(self.delegate!.tableHeaderViewHeight(in: self))
            tableHeaderContainerView?.frame = bounds!
            mainTableView.tableHeaderView = tableHeaderContainerView
        }
    }

    open func preferredProcessListViewDidScroll(scrollView: UIScrollView) {
        if (self.mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            //mainTableView的header还没有消失，让listScrollView一直为0
            self.currentList?.listScrollViewWillResetContentOffset?()
            setListScrollViewToMinContentOffsetY(currentScrollingListView!)
            if automaticallyDisplayListVerticalScrollIndicator {
                currentScrollingListView!.showsVerticalScrollIndicator = false
            }
        } else {
            //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
            setMainTableViewToMaxContentOffsetY()
            if automaticallyDisplayListVerticalScrollIndicator {
                currentScrollingListView!.showsVerticalScrollIndicator = true
            }
        }
    }

    open func preferredProcessMainTableViewDidScroll(_ scrollView: UIScrollView) {
        if (self.currentScrollingListView != nil && self.currentScrollingListView!.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView!)) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            setMainTableViewToMaxContentOffsetY()
        }

        if (self.mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            //mainTableView已经显示了header，listView的contentOffset需要重置
            for list in self.validListDict.values {
                list.listScrollViewWillResetContentOffset?()
                setListScrollViewToMinContentOffsetY(list.listScrollView())
            }
        }

        if self.currentScrollingListView != nil && scrollView.contentOffset.y > mainTableViewMaxContentOffsetY() && self.currentScrollingListView?.contentOffset.y == minContentOffsetYInListScrollView(currentScrollingListView!) {
            //当往上滚动mainTableView的headerView时，滚动到底时，修复listView往上小幅度滚动
            setMainTableViewToMaxContentOffsetY()
        }
    }

    //MARK: - Private

    func refreshTableHeaderView() {
        guard self.delegate != nil else {
            return
        }
        let tableHeaderView = self.delegate!.tableHeaderView(in: self)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat(self.delegate!.tableHeaderViewHeight(in: self))))
        containerView.addSubview(tableHeaderView)
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: tableHeaderView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: tableHeaderView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableHeaderView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: tableHeaderView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
        containerView.addConstraints([top, leading, bottom, trailing])
        tableHeaderContainerView = containerView
        mainTableView.tableHeaderView = containerView
    }

    func adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets) {
        if mainTableView.contentInset != inset {
            mainTableView.contentInset = inset
        }
    }

    func refreshListHorizontalScrollEnabledState() {
        listContainerView.collectionView.isScrollEnabled = isListHorizontalScrollEnabled
    }

    func mainTableViewMaxContentOffsetY() -> CGFloat {
        guard self.delegate != nil else {
            return 0
        }
        return CGFloat(self.delegate!.tableHeaderViewHeight(in: self)) - CGFloat(pinSectionHeaderVerticalOffset)
    }

    func setMainTableViewToMaxContentOffsetY() {
        mainTableView.contentOffset = CGPoint(x: 0, y: mainTableViewMaxContentOffsetY())
    }

    func minContentOffsetYInListScrollView(_ scrollView: UIScrollView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return -scrollView.adjustedContentInset.top
        }
        return -scrollView.contentInset.top
    }

    func setListScrollViewToMinContentOffsetY(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: minContentOffsetYInListScrollView(scrollView))
    }

    func pinSectionHeaderHeight() -> CGFloat {
        guard self.delegate != nil else {
            return 0
        }
        return CGFloat(self.delegate!.heightForPinSectionHeader(in: self))
    }

    /// 外部传入的listView，当其内部的scrollView滚动时，需要调用该方法
    func listViewDidScroll(scrollView: UIScrollView) {
        self.currentScrollingListView = scrollView

        preferredProcessListViewDidScroll(scrollView: scrollView)
    }

    @objc func deviceOrientationDidChange(notification: Notification) {
        guard isDeviceOrientationChangeEnabled else {
            return
        }
        if self.currentDeviceOrientation != UIDevice.current.orientation {
            self.currentDeviceOrientation = UIDevice.current.orientation
            //前后台切换也会触发该通知，所以不相同的时候才处理
            mainTableView.reloadData()
            listContainerView.deviceOrientationDidChanged()
            listContainerView.reloadData()
        }
    }

    @objc func currentListDidDisappear() {
        let list = self.validListDict[self.currentIndex]
        list?.listDidDisappear?()
        self.isWillRemoveFromWindow = false
        self.retainedSelf = nil
    }

    func currentListDidAppear() {
        self.listDidAppear(index: self.currentIndex)
    }

    func listDidAppear(index: Int) {
        guard self.delegate != nil else {
            return
        }
        let count = self.delegate!.numberOfLists(in: self)
        if count <= 0 || index >= count {
            return
        }
        self.currentIndex = index
        let list = self.validListDict[index]
        list?.listDidAppear?()
    }

    func listDidDisappear(index: Int) {
        guard self.delegate != nil else {
            return
        }
        let count = self.delegate!.numberOfLists(in: self)
        if count <= 0 || index >= count {
            return
        }
        let list = self.validListDict[index]
        list?.listDidDisappear?()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension JXPagingView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.bounds.height - pinSectionHeaderHeight() - CGFloat(pinSectionHeaderVerticalOffset)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        listContainerView.frame = cell.bounds
        cell.contentView.addSubview(listContainerView)
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return pinSectionHeaderHeight()
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.delegate != nil else {
            return UIView()
        }
        return self.delegate!.viewForPinSectionHeader(in: self)
    }

    //加上footer之后，下滑滚动就变得丝般顺滑了
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect.zero)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if CGFloat(pinSectionHeaderVerticalOffset) != 0 {
            if scrollView.contentOffset.y < CGFloat(pinSectionHeaderVerticalOffset) {
                //因为设置了contentInset.top，所以顶部会有对应高度的空白区间，所以需要设置负数抵消掉
                if scrollView.contentOffset.y >= 0 {
                    adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0))
                }
            }else if scrollView.contentOffset.y > CGFloat(pinSectionHeaderVerticalOffset) {
                //固定的位置就是contentInset.top
                adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets(top: CGFloat(pinSectionHeaderVerticalOffset), left: 0, bottom: 0, right: 0))
            }
        }

        preferredProcessMainTableViewDidScroll(scrollView)

        self.delegate?.mainTableViewDidScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isListHorizontalScrollEnabled {
            //用户正在上下滚动的时候，就不允许左右滚动
            self.listContainerView.collectionView.isScrollEnabled = false
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isListHorizontalScrollEnabled && !decelerate {
            self.listContainerView.collectionView.isScrollEnabled = true
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isListHorizontalScrollEnabled {
            self.listContainerView.collectionView.isScrollEnabled = true
        }
        if mainTableView.contentInset.top != 0 && pinSectionHeaderVerticalOffset != 0 {
            adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets.zero)
        }
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isListHorizontalScrollEnabled {
            self.listContainerView.collectionView.isScrollEnabled = true
        }
    }
}

extension JXPagingView: JXPagingListContainerViewDelegate {
    public func numberOfRows(in listContainerView: JXPagingListContainerView) -> Int {
        guard self.delegate != nil else {
            return 0
        }
        return self.delegate!.numberOfLists(in: self)
    }

    public func listContainerView(_ listContainerView: JXPagingListContainerView, viewForListInRow row: Int) -> UIView {
        guard self.delegate != nil else {
            return UIView()
        }
        var list = validListDict[row]
        if list == nil {
            list = self.delegate!.pagingView(self, initListAtIndex: row)
            list?.listViewDidScrollCallback {[weak self, weak list] (scrollView) in
                self?.currentList = list
                self?.listViewDidScroll(scrollView: scrollView)
            }
            validListDict[row] = list!
        }
        for listItem in validListDict.values {
            if listItem === list {
                listItem.listScrollView().scrollsToTop = true
            }else {
                listItem.listScrollView().scrollsToTop = false
            }
        }
        return list!.listView()
    }

    public func listContainerView(_ listContainerView: JXPagingListContainerView, willDisplayCellAt row: Int) {
        self.listDidAppear(index: row)
        self.currentScrollingListView = validListDict[row]?.listScrollView()
    }

    public func listContainerView(_ listContainerView: JXPagingListContainerView, didEndDisplayingCellAt row: Int) {
        self.listDidDisappear(index: row)
    }
}



