//
//  DQEventMatchLiveListContainerView.swift
//  DQGuess
//
//  Created by jiaxin on 2018/5/16.
//  Copyright © 2018年 jingbo. All rights reserved.
//

import UIKit

@objc public protocol JXPagingListContainerViewDelegate {

    func numberOfRows(in listContainerView: JXPagingListContainerView) -> Int

    func listContainerView(_ listContainerView: JXPagingListContainerView, viewForListInRow row: Int) -> UIView

    func listContainerView(_ listContainerView: JXPagingListContainerView, willDisplayCellAt row: Int)

    func listContainerView(_ listContainerView: JXPagingListContainerView, didEndDisplayingCellAt row: Int)
}

@objc public protocol JXPagingListContainerCollectionViewGestureDelegate {
    @objc optional func pagingListContainerCollectionView(_ collectionView: JXPagingListContainerCollectionView, gestureRecognizerShouldBegin gestureRecognizer: UIGestureRecognizer) -> Bool
    @objc optional func pagingListContainerCollectionView(_ collectionView: JXPagingListContainerCollectionView, gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

public class JXPagingListContainerCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    public var isNestEnabled = false
    public weak var gestureDelegate: JXPagingListContainerCollectionViewGestureDelegate?

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //如果有代理，就以代理的处理为准
        if let result = self.gestureDelegate?.pagingListContainerCollectionView?(self, gestureRecognizerShouldBegin: gestureRecognizer) {
            return result
        }else {
            if isNestEnabled {
                //没有代理，但是isNestEnabled为true
                if gestureRecognizer.isMember(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) {
                    let panGesture = gestureRecognizer as! UIPanGestureRecognizer
                    let velocityX = panGesture.velocity(in: panGesture.view!).x
                    if velocityX > 0 {
                        //当前在第一个页面，且往左滑动，就放弃该手势响应，让外层接收，达到多个PagingView左右切换效果
                        if self.contentOffset.x == 0 {
                            return false
                        }
                    }else if velocityX < 0 {
                        //当前在最后一个页面，且往右滑动，就放弃该手势响应，让外层接收，达到多个PagingView左右切换效果
                        if self.contentOffset.x + self.bounds.size.width == self.contentSize.width {
                            return false
                        }
                    }
                }
                return true
            }
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let result = gestureDelegate?.pagingListContainerCollectionView?(self, gestureRecognizer: gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) {
            return result
        }
        return false;
    }
}

open class JXPagingListContainerView: UIView {
    /// 需要和self.categoryView.defaultSelectedIndex保持一致
    open var defaultSelectedIndex: Int = 0
    open var collectionView: JXPagingListContainerCollectionView!
    unowned var delegate: JXPagingListContainerViewDelegate
    weak var mainTableView: JXPagingMainTableView?

    private var selectedIndexPath: IndexPath?
    private var isFirstLayoutSubviews: Bool = true

    public init(delegate: JXPagingListContainerViewDelegate) {
        self.delegate = delegate

        super.init(frame: CGRect.zero)

        self.initializeViews()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func initializeViews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = JXPagingListContainerCollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        self.addSubview(collectionView)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = self.bounds
        if selectedIndexPath != nil && self.delegate.numberOfRows(in: self) >= 1 + selectedIndexPath!.item {
            collectionView.scrollToItem(at: selectedIndexPath!, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
        if isFirstLayoutSubviews {
            isFirstLayoutSubviews = false
            collectionView.setContentOffset(CGPoint(x: self.collectionView.bounds.size.width*CGFloat(self.defaultSelectedIndex), y: 0), animated: false)
        }
    }

    open func reloadData() {
        self.collectionView.reloadData()
    }

    open func deviceOrientationDidChanged() {
        if bounds.size.width > 0 {
            selectedIndexPath = IndexPath(item: Int(collectionView.contentOffset.x/bounds.size.width), section: 0)
        }
    }
}

extension JXPagingListContainerView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate.numberOfRows(in: self)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let listView = self.delegate.listContainerView(self, viewForListInRow: indexPath.item)
        listView.frame = cell.bounds
        cell.contentView.addSubview(listView)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.delegate.listContainerView(self, willDisplayCellAt: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.delegate.listContainerView(self, didEndDisplayingCellAt: indexPath.item)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.mainTableView?.isScrollEnabled = false
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.mainTableView?.isScrollEnabled = true
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.mainTableView?.isScrollEnabled = true
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.mainTableView?.isScrollEnabled = true
    }
}

extension JXPagingListContainerView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
}
