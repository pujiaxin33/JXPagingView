//
//  ListRefreshViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView

class ListRefreshViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNeedHeader = true
    }

    override func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }

    //用于测试每次点击segment切换，都触发子列表的下拉刷新
/*
    override func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        super.segmentedView(segmentedView, didSelectedItemAt: index)

        guard let list = pagingView.validListDict[index] as? ListViewController else {
            return
        }
        list.tableView.mj_header?.beginRefreshing()
    }
 */
}
