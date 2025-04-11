//
//  PagingNestPagingExampleViewController.swift
//  JXPagingViewExample
//
//  Created by Jason on 2025/4/11.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView
import MJRefresh

class PagingNestPagingExampleViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = true
        
        self.pagingView.mainTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
    }
    
    override func preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self, listContainerType: .scrollView)
    }
    
    override func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if checkIsNestContainerScrollView(gestureRecognizer.view) || checkIsNestContainerScrollView(otherGestureRecognizer.view) {
            //如果交互的是嵌套的listContainerView的容器ScrollView，证明在左右滑动，就不允许同时响应
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
    
    override func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> any JXPagingViewListViewDelegate {
        var subpageType: PagingNestPagingSubpageViewController.SubpageType
        if index == 0 {
            subpageType = .capability
        } else if index == 1 {
            subpageType = .hobby
        } else {
            subpageType = .partner
        }
        let page = PagingNestPagingSubpageViewController(type: subpageType)
        page.nestContentScrollView = pagingView.listContainerView.contentScrollView()
        return page
    }

    func checkIsNestContainerScrollView(_ view: UIView?) -> Bool {
        guard let scrollView: UIScrollView = view as? UIScrollView else {
            return false
        }
        guard let listArray = Array(self.pagingView.validListDict.values) as? [PagingNestPagingSubpageViewController] else {
            return false
        }
        
        for list in listArray {
            if list.containerScrollViews.contains(scrollView) {
                return true
            }
        }
        return false
    }
    
    @objc func headerRefresh() {
        mockHeaderRefreshLoadNewData()
    }
    
    func mockHeaderRefreshLoadNewData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            self.pagingView.mainTableView.mj_header?.endRefreshing()
        }
    }
}

