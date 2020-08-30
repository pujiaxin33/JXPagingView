//
//  JXPagingSmoothView.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/11/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

@objc public protocol JXPagingSmoothViewListViewDelegate {
    /// 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。
    func listView() -> UIView
    /// 返回JXPagerSmoothViewListViewDelegate内部持有的UIScrollView或UITableView或UICollectionView
    func listScrollView() -> UIScrollView
    @objc optional func listDidAppear()
    @objc optional func listDidDisappear()
}

@objc
public protocol JXPagingSmoothViewDataSource {
    /// 返回页面header的高度
    func heightForPagingHeader(in pagingView: JXPagingSmoothView) -> CGFloat
    /// 返回页面header视图
    func viewForPagingHeader(in pagingView: JXPagingSmoothView) -> UIView
    /// 返回悬浮视图的高度
    func heightForPinHeader(in pagingView: JXPagingSmoothView) -> CGFloat
    /// 返回悬浮视图
    func viewForPinHeader(in pagingView: JXPagingSmoothView) -> UIView
    /// 返回列表的数量
    func numberOfLists(in pagingView: JXPagingSmoothView) -> Int
    /// 根据index初始化一个对应列表实例，需要是遵从`JXPagingSmoothViewListViewDelegate`协议的对象。
    /// 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXPagingSmoothViewListViewDelegate`协议，该方法返回自定义UIView即可。
    /// 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXPagingSmoothViewListViewDelegate`协议，该方法返回自定义UIViewController即可。
    func pagingView(_ pagingView: JXPagingSmoothView, initListAtIndex index: Int) -> JXPagingSmoothViewListViewDelegate
}

@objc
public protocol JXPagingSmoothViewDelegate {
    @objc optional func pagingSmoothViewDidScroll(_ scrollView: UIScrollView)
}


open class JXPagingSmoothView: UIView {
    public private(set) var listDict = [Int : JXPagingSmoothViewListViewDelegate]()
    public let listCollectionView: JXPagingSmoothCollectionView
    public var defaultSelectedIndex: Int = 0
    public weak var delegate: JXPagingSmoothViewDelegate?

    weak var dataSource: JXPagingSmoothViewDataSource?
    var listHeaderDict = [Int : UIView]()
    var isSyncListContentOffsetEnabled: Bool = false
    let pagingHeaderContainerView: UIView
    var currentPagingHeaderContainerViewY: CGFloat = 0
    var currentIndex: Int = 0
    var currentListScrollView: UIScrollView?
    var heightForPagingHeader: CGFloat = 0
    var heightForPinHeader: CGFloat = 0
    var heightForPagingHeaderContainerView: CGFloat = 0
    let cellIdentifier = "cell"
    var currentListInitializeContentOffsetY: CGFloat = 0
    var singleScrollView: UIScrollView?

    deinit {
        listDict.values.forEach {
            $0.listScrollView().removeObserver(self, forKeyPath: "contentOffset")
            $0.listScrollView().removeObserver(self, forKeyPath: "contentSize")
        }
    }

    public init(dataSource: JXPagingSmoothViewDataSource) {
        self.dataSource = dataSource
        pagingHeaderContainerView = UIView()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        listCollectionView = JXPagingSmoothCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(frame: CGRect.zero)

        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        listCollectionView.isPagingEnabled = true
        listCollectionView.bounces = false
        listCollectionView.showsHorizontalScrollIndicator = false
        listCollectionView.scrollsToTop = false
        listCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        if #available(iOS 10.0, *) {
            listCollectionView.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *) {
            listCollectionView.contentInsetAdjustmentBehavior = .never
        }
        listCollectionView.pagingHeaderContainerView = pagingHeaderContainerView
        addSubview(listCollectionView)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData() {
        guard let dataSource = dataSource else { return }
        currentListScrollView = nil
        currentIndex = defaultSelectedIndex
        currentPagingHeaderContainerViewY = 0
        isSyncListContentOffsetEnabled = false

        listHeaderDict.removeAll()
        listDict.values.forEach { (list) in
            list.listScrollView().removeObserver(self, forKeyPath: "contentOffset")
            list.listScrollView().removeObserver(self, forKeyPath: "contentSize")
            list.listView().removeFromSuperview()
        }
        listDict.removeAll()

        heightForPagingHeader = dataSource.heightForPagingHeader(in: self)
        heightForPinHeader = dataSource.heightForPinHeader(in: self)
        heightForPagingHeaderContainerView = heightForPagingHeader + heightForPinHeader

        let pagingHeader = dataSource.viewForPagingHeader(in: self)
        let pinHeader = dataSource.viewForPinHeader(in: self)
        pagingHeaderContainerView.addSubview(pagingHeader)
        pagingHeaderContainerView.addSubview(pinHeader)

        pagingHeaderContainerView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: heightForPagingHeaderContainerView)
        pagingHeader.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: heightForPagingHeader)
        pinHeader.frame = CGRect(x: 0, y: heightForPagingHeader, width: bounds.size.width, height: heightForPinHeader)
        listCollectionView.setContentOffset(CGPoint(x: listCollectionView.bounds.size.width*CGFloat(defaultSelectedIndex), y: 0), animated: false)
        listCollectionView.reloadData()

        if dataSource.numberOfLists(in: self) == 0 {
            singleScrollView = UIScrollView()
            addSubview(singleScrollView!)
            singleScrollView?.addSubview(pagingHeader)
            singleScrollView?.contentSize = CGSize(width: bounds.size.width, height: heightForPagingHeader)
        }else if singleScrollView != nil {
            singleScrollView?.removeFromSuperview()
            singleScrollView = nil
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        listCollectionView.frame = bounds
        if pagingHeaderContainerView.frame == CGRect.zero {
            reloadData()
        }
        if singleScrollView != nil {
            singleScrollView?.frame = bounds
        }
    }

    func listDidScroll(scrollView: UIScrollView) {
        if listCollectionView.isDragging || listCollectionView.isDecelerating {
            return
        }
        let index = listIndex(for: scrollView)
        if index != currentIndex {
            return
        }
        currentListScrollView = scrollView
        let contentOffsetY = scrollView.contentOffset.y + heightForPagingHeaderContainerView
        if contentOffsetY < heightForPagingHeader {
            isSyncListContentOffsetEnabled = true
            currentPagingHeaderContainerViewY = -contentOffsetY
            for list in listDict.values {
                if list.listScrollView() != currentListScrollView {
                    list.listScrollView().setContentOffset(scrollView.contentOffset, animated: false)
                }
            }
            let header = listHeader(for: scrollView)
            if pagingHeaderContainerView.superview != header {
                pagingHeaderContainerView.frame.origin.y = 0
                header?.addSubview(pagingHeaderContainerView)
            }
        }else {
            if pagingHeaderContainerView.superview != self {
                pagingHeaderContainerView.frame.origin.y = -heightForPagingHeader
                addSubview(pagingHeaderContainerView)
            }
            if isSyncListContentOffsetEnabled {
                isSyncListContentOffsetEnabled = false
                currentPagingHeaderContainerViewY = -heightForPagingHeader
                for list in listDict.values {
                    if list.listScrollView() != currentListScrollView {
                        list.listScrollView().setContentOffset(CGPoint(x: 0, y: -heightForPinHeader), animated: false)
                    }
                }
            }
        }
    }

    //MARK: - KVO

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let scrollView = object as? UIScrollView {
                listDidScroll(scrollView: scrollView)
            }
        }else if keyPath == "contentSize" {
            if let scrollView = object as? UIScrollView {
                let minContentSizeHeight = bounds.size.height - heightForPinHeader
                if minContentSizeHeight > scrollView.contentSize.height {
                    scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: minContentSizeHeight)
                    //新的scrollView第一次加载的时候重置contentOffset
                    if currentListScrollView != nil, scrollView != currentListScrollView! {
                        scrollView.contentOffset = CGPoint(x: 0, y: currentListInitializeContentOffsetY)
                    }
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    //MARK: - Private
    func listHeader(for listScrollView: UIScrollView) -> UIView? {
        for (index, list) in listDict {
            if list.listScrollView() == listScrollView {
                return listHeaderDict[index]
            }
        }
        return nil
    }

    func listIndex(for listScrollView: UIScrollView) -> Int {
        for (index, list) in listDict {
            if list.listScrollView() == listScrollView {
                return index
            }
        }
        return 0
    }

    func listDidAppear(at index: Int) {
        guard let dataSource = dataSource else { return }
        let count = dataSource.numberOfLists(in: self)
        if count <= 0 || index >= count {
            return
        }
        listDict[index]?.listDidAppear?()
    }

    func listDidDisappear(at index: Int) {
        guard let dataSource = dataSource else { return }
        let count = dataSource.numberOfLists(in: self)
        if count <= 0 || index >= count {
            return
        }
        listDict[index]?.listDidDisappear?()
    }

    /// 列表左右切换滚动结束之后，需要把pagerHeaderContainerView添加到当前index的列表上面
    func horizontalScrollDidEnd(at index: Int) {
        currentIndex = index
        guard let listHeader = listHeaderDict[index], let listScrollView = listDict[index]?.listScrollView() else {
            return
        }
        listDict.values.forEach { $0.listScrollView().scrollsToTop = ($0.listScrollView() === listScrollView) }
        if listScrollView.contentOffset.y <= -heightForPinHeader {
            pagingHeaderContainerView.frame.origin.y = 0
            listHeader.addSubview(pagingHeaderContainerView)
        }
    }
}

extension JXPagingSmoothView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.numberOfLists(in: self)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else { return UICollectionViewCell(frame: CGRect.zero) }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        var list = listDict[indexPath.item]
        if list == nil {
            list = dataSource.pagingView(self, initListAtIndex: indexPath.item)
            listDict[indexPath.item] = list!
            list?.listView().setNeedsLayout()
            list?.listView().layoutIfNeeded()
            if list?.listScrollView().isKind(of: UITableView.self) == true {
                (list?.listScrollView() as? UITableView)?.estimatedRowHeight = 0
                (list?.listScrollView() as? UITableView)?.estimatedSectionHeaderHeight = 0
                (list?.listScrollView() as? UITableView)?.estimatedSectionFooterHeight = 0
            }
            if #available(iOS 11.0, *) {
                list?.listScrollView().contentInsetAdjustmentBehavior = .never
            }
            list?.listScrollView().contentInset = UIEdgeInsets(top: heightForPagingHeaderContainerView, left: 0, bottom: 0, right: 0)
            currentListInitializeContentOffsetY = -heightForPagingHeaderContainerView + min(-currentPagingHeaderContainerViewY, heightForPagingHeader)
            list?.listScrollView().contentOffset = CGPoint(x: 0, y: currentListInitializeContentOffsetY)
            let listHeader = UIView(frame: CGRect(x: 0, y: -heightForPagingHeaderContainerView, width: bounds.size.width, height: heightForPagingHeaderContainerView))
            list?.listScrollView().addSubview(listHeader)
            if pagingHeaderContainerView.superview == nil {
                listHeader.addSubview(pagingHeaderContainerView)
            }
            listHeaderDict[indexPath.item] = listHeader
            list?.listScrollView().addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            list?.listScrollView().addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }
        listDict.values.forEach { $0.listScrollView().scrollsToTop = ($0 === list) }
        if let listView = list?.listView(), listView.superview != cell.contentView {
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            listView.frame = cell.contentView.bounds
            cell.contentView.addSubview(listView)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        listDidAppear(at: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        listDidDisappear(at: indexPath.item)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.pagingSmoothViewDidScroll?(scrollView)
        let indexPercent = scrollView.contentOffset.x/scrollView.bounds.size.width
        let index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        let listScrollView = listDict[index]?.listScrollView()
        if (indexPercent - CGFloat(index) == 0) && index != currentIndex && !(scrollView.isDragging || scrollView.isDecelerating) && listScrollView?.contentOffset.y ?? 0 <= -heightForPinHeader {
            horizontalScrollDidEnd(at: index)
        }else {
            //左右滚动的时候，就把listHeaderContainerView添加到self，达到悬浮在顶部的效果
            if pagingHeaderContainerView.superview != self {
                pagingHeaderContainerView.frame.origin.y = currentPagingHeaderContainerViewY
                addSubview(pagingHeaderContainerView)
            }
        }
        if index != currentIndex {
            currentIndex = index
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            let index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
            horizontalScrollDidEnd(at: index)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        horizontalScrollDidEnd(at: index)
    }
}

public class JXPagingSmoothCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    var pagingHeaderContainerView: UIView?
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: pagingHeaderContainerView)
        if pagingHeaderContainerView?.bounds.contains(point) == true {
            return false
        }
        return true
    }
}
