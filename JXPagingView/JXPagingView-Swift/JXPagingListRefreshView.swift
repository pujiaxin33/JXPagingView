//
//  JXPagingListRefreshView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class JXPagingListRefreshView: JXPagingView {
    fileprivate var lastScrollingListViewContentOffsetY: CGFloat = 0

    override func initializeViews() {
        super.initializeViews()

        mainTableView.bounces = false
    }

    override open func preferredProcessMainTableViewDidScroll(_ scrollView: UIScrollView) {
        if (self.currentScrollingListView != nil && self.currentScrollingListView!.contentOffset.y > 0) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            self.mainTableView.contentOffset = CGPoint(x: 0, y: self.delegate.tableHeaderViewHeight(in: self))
        }

        if (mainTableView.contentOffset.y < self.delegate.tableHeaderViewHeight(in: self)) {
            //mainTableView已经显示了header，listView的contentOffset需要重置
            for index in 0..<self.delegate.numberOfListViews(in: self) {
                let listView = self.delegate.pagingView(self, listViewInRow: index)
                //正在下拉刷新时，不需要重置
                if listView.listScrollView().contentOffset.y > 0 {
                    listView.listScrollView().contentOffset = CGPoint.zero
                }
            }
        }
    }
    
    override func preferredProcessListViewDidScroll(scrollView: UIScrollView) {
        var shouldProcess = true
        if currentScrollingListView!.contentOffset.y > self.lastScrollingListViewContentOffsetY {
            //往上滚动
        }else {
            //往下滚动
            if self.mainTableView.contentOffset.y == 0 {
                shouldProcess = false
            }else {
                if (self.mainTableView.contentOffset.y < self.delegate.tableHeaderViewHeight(in: self)) {
                    //mainTableView的header还没有消失，让listScrollView一直为0
                    currentScrollingListView!.contentOffset = CGPoint.zero;
                    currentScrollingListView!.showsVerticalScrollIndicator = false;
                }
            }
        }
        if shouldProcess {
            if (self.mainTableView.contentOffset.y < self.delegate.tableHeaderViewHeight(in: self)) {
                //处于下拉刷新的状态，scrollView.contentOffset.y为负数，就重置为0
                if currentScrollingListView!.contentOffset.y > 0 {
                    //mainTableView的header还没有消失，让listScrollView一直为0
                    currentScrollingListView!.contentOffset = CGPoint.zero;
                    currentScrollingListView!.showsVerticalScrollIndicator = false;
                }
            } else {
                //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
                self.mainTableView.contentOffset = CGPoint(x: 0, y: self.delegate.tableHeaderViewHeight(in: self));
                currentScrollingListView!.showsVerticalScrollIndicator = true;
            }
        }
        self.lastScrollingListViewContentOffsetY = currentScrollingListView!.contentOffset.y;
    }


}
