//
//  JXPagingView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

//该协议主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
@objc protocol JXPagingViewListViewDelegate: NSObjectProtocol {
    var scrollView: UIScrollView { get }
}

@objc protocol JXPagingViewDelegate: NSObjectProtocol {


    /// tableHeaderView的高度
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: height
    func tableHeaderViewHeight(in pagingView: JXPagingViewView) -> CGFloat


    /// 返回tableHeaderView
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: view
    func tableHeaderView(in pagingView: JXPagingViewView) -> UIView


    /// 返回悬浮HeaderView的高度。
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: height
    func heightForHeaderInSection(in pagingView: JXPagingViewView) -> CGFloat


    /// 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: view
    func viewForHeaderInSection(in pagingView: JXPagingViewView) -> UIView


    /// 底部listView的条数
    ///
    /// - Parameter pagingView: JXPagingViewView
    /// - Returns: count
    func numberOfListViews(in pagingView: JXPagingViewView) -> Int


    /// 返回对应index的listView，需要是UIView的子类，且要遵循JXPagingViewListViewDelegate。
    /// 这里要求返回一个UIView而不是一个UIScrollView，因为listView可能并不只是一个单纯的UITableView或UICollectionView，可能还会有其他的子视图。
    ///
    /// - Parameters:
    ///   - pagingView: JXPagingViewView
    ///   - row: row
    /// - Returns: view
    func pagingView(_ pagingView: JXPagingViewView, listViewInRow row: Int) -> JXPagingViewListViewDelegate & UIView


    /// mainTableView的滚动回调，用于实现头图跟随缩放
    ///
    /// - Parameter scrollView: JXPagingViewMainTableView
    @objc optional func mainTableViewDidScroll(_ scrollView: UIScrollView)
}

class JXPagingViewView: UIView {
    open unowned var delegate: JXPagingViewDelegate
    open var mainTableView: JXPagingViewMainTableView!
    open var listContainerView: JXPagingViewListContainerView!
    fileprivate var currentScrollingListView: UIScrollView?

    init(delegate: JXPagingViewDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)

        initializeViews()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initializeViews(){
        mainTableView = JXPagingViewMainTableView(frame: CGRect.zero, style: .plain)
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.separatorStyle = .none
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.tableHeaderView = self.delegate.tableHeaderView(in: self)
        mainTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        addSubview(mainTableView)

        listContainerView = JXPagingViewListContainerView(delegate: self)
        listContainerView.mainTableView = mainTableView
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        mainTableView.frame = self.bounds
    }

    /// 外部传入的listView，当其内部的scrollView滚动时，需要调用该方法
    open func listViewDidScroll(scrollView: UIScrollView) {
        self.currentScrollingListView = scrollView

        if (self.mainTableView.contentOffset.y < self.delegate.tableHeaderViewHeight(in: self)) {
            //mainTableView的header还没有消失，让listScrollView一直为0
            scrollView.contentOffset = CGPoint.zero;
            scrollView.showsVerticalScrollIndicator = false;
        } else {
            //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
            self.mainTableView.contentOffset = CGPoint(x: 0, y: self.delegate.tableHeaderViewHeight(in: self));
            scrollView.showsVerticalScrollIndicator = true;
        }
    }

    open func reloadData() {
        self.mainTableView.reloadData()
        self.listContainerView.reloadData()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension JXPagingViewView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.bounds.height - self.delegate.heightForHeaderInSection(in: self)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        listContainerView.frame = cell.contentView.bounds
        cell.contentView.addSubview(listContainerView)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.delegate.heightForHeaderInSection(in: self)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.delegate.viewForHeaderInSection(in: self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate.mainTableViewDidScroll?(scrollView)

        if (self.currentScrollingListView != nil && self.currentScrollingListView!.contentOffset.y > 0) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            self.mainTableView.contentOffset = CGPoint(x: 0, y: self.delegate.tableHeaderViewHeight(in: self))
        }

        if (scrollView.contentOffset.y < self.delegate.tableHeaderViewHeight(in: self)) {
            //mainTableView已经显示了header，listView的contentOffset需要重置
            for index in 0..<self.delegate.numberOfListViews(in: self) {
                let listView = self.delegate.pagingView(self, listViewInRow: index)
                listView.scrollView.contentOffset = CGPoint.zero
            }
        }
    }
}

extension JXPagingViewView: JXPagingViewListContainerViewDelegate {
    func numberOfRows(in listContainerView: JXPagingViewListContainerView) -> Int {
        return self.delegate.numberOfListViews(in: self)
    }
    func listContainerView(_ listContainerView: JXPagingViewListContainerView, viewForListInRow row: Int) -> UIView {
        return self.delegate.pagingView(self, listViewInRow: row)
    }
}



