//
//  PagingNestCategoryExampleViewController.swift
//  JXPagingViewExample
//
//  Created by Jason on 2025/3/14.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import MJRefresh

class PagingNestCategoryExampleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = true
        self.pagingView.mainTableView.mj_header =  MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
    }
    
    @objc private func headerRefresh() {
        guard let currentList = self.pagingView.validListDict[self.segmentedView.selectedIndex] as? PagingNestCategoryFirstLayerViewController else {
            return
        }
        
        currentList.headerRefresh()
    }
    
    override func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if checkIsNestContentScrollView(gestureRecognizer.view) || checkIsNestContentScrollView(otherGestureRecognizer.view) {
            //如果交互的是嵌套的contentScrollView，证明在左右滑动，就不允许同时响应
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
    
    override func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> any JXPagingViewListViewDelegate {
        let page = PagingNestCategoryFirstLayerViewController()
        page.refreshDelegate = self
        return page
    }

    func checkIsNestContentScrollView(_ view: UIView?) -> Bool {
        guard let scrollView: UIScrollView = view as? UIScrollView else {
            return false
        }
        guard let listArray = Array(self.pagingView.validListDict.values) as? [PagingNestCategoryFirstLayerViewController] else {
            return false
        }
        
        for list in listArray {
            if list.contentScrollView == scrollView {
                return true
            }
        }
        return false
    }
}

extension PagingNestCategoryExampleViewController: ListViewControllerHeaderAndFooterRefreshEventProtocol {
    func endHeaderRefresh() {
        self.pagingView.mainTableView.mj_header?.endRefreshing()
    }
    
    func endFooterLoadMore() {
        self.pagingView.mainTableView.mj_footer?.endRefreshing()
    }
}
