//
//  PagingNestTwoCategoryExampleViewController.swift
//  JXPagingViewExample
//
//  Created by Jason on 2025/3/14.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import MJRefresh

class PagingNestTwoCategoryExampleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = true
        self.pagingView.mainTableView.mj_header =  MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
    }
    
    @objc private func headerRefresh() {
        guard let currentList = self.pagingView.validListDict[self.segmentedView.selectedIndex] as? PagingNestTwoCategoryFirstLayerViewController else {
            return
        }
        
        currentList.headerRefresh()
    }
    
    override func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if checkIsNestContainerScrollView(gestureRecognizer.view) || checkIsNestContainerScrollView(otherGestureRecognizer.view) {
            //如果交互的是嵌套的listContainerView的容器ScrollView，证明在左右滑动，就不允许同时响应
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
    
    override func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> any JXPagingViewListViewDelegate {
        let page = PagingNestTwoCategoryFirstLayerViewController()
        page.refreshDelegate = self
        return page
    }

    func checkIsNestContainerScrollView(_ view: UIView?) -> Bool {
        guard let scrollView: UIScrollView = view as? UIScrollView else {
            return false
        }
        guard let listArray = Array(self.pagingView.validListDict.values) as? [PagingNestTwoCategoryFirstLayerViewController] else {
            return false
        }
        
        for list in listArray {
            if list.containerScrollViews.contains(scrollView) {
                return true
            }
        }
        return false
    }
}

extension PagingNestTwoCategoryExampleViewController: ListViewControllerHeaderAndFooterRefreshEventProtocol {
    func endHeaderRefresh() {
        self.pagingView.mainTableView.mj_header?.endRefreshing()
    }
    
    func endFooterLoadMore() {
        self.pagingView.mainTableView.mj_footer?.endRefreshing()
    }
}
