//
//  RefreshViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import MJRefresh

class RefreshViewController: BaseViewController {
    var isHeaderRefreshed = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNeedFooter = true

        pagingView.mainTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
    }

    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.isHeaderRefreshed = true

            self.titles = ["高级-能力", "高级-爱好", "高级-队友"]
            self.dataSource.titles = self.titles
            self.dataSource.reloadData(selectedIndex: 0)
            
            self.segmentedView.defaultSelectedIndex = 0
            self.segmentedView.reloadData()

            self.pagingView.mainTableView.mj_header?.endRefreshing()
            self.pagingView.reloadData()
        }
    }

    override func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if !isHeaderRefreshed {
            return super.pagingView(pagingView, initListAtIndex: index)
        }
        let list = ListViewController()
        list.isNeedHeader = isNeedHeader
        list.isNeedFooter = isNeedFooter
        if index == 0 {
            list.dataSource = ["高级-高级-橡胶火箭", "高级-橡胶火箭炮", "高级-橡胶机关枪", "高级-橡胶子弹", "高级-橡胶攻城炮", "高级-橡胶象枪", "高级-橡胶象枪乱打", "高级-橡胶灰熊铳", "高级-橡胶雷神象枪", "高级-橡胶猿王枪", "高级-橡胶犀·榴弹炮", "高级-橡胶大蛇炮", "高级-橡胶火箭", "高级-橡胶火箭炮", "高级-橡胶机关枪", "高级-橡胶子弹", "高级-橡胶攻城炮", "高级-橡胶象枪", "高级-橡胶象枪乱打", "高级-橡胶灰熊铳", "高级-橡胶雷神象枪", "高级-橡胶猿王枪", "高级-橡胶犀·榴弹炮", "高级-橡胶大蛇炮"]
        }else if index == 1 {
            list.dataSource = ["高级-吃烤肉", "高级-吃鸡腿肉", "高级-吃牛肉", "高级-各种肉"]
        }else {
            list.dataSource = ["高级-【剑士】罗罗诺亚·索隆", "高级-【航海士】娜美", "高级-【狙击手】乌索普", "高级-【厨师】香吉士", "高级-【船医】托尼托尼·乔巴", "高级-【船匠】 弗兰奇", "高级-【音乐家】布鲁克", "高级-【考古学家】妮可·罗宾"]
        }
        return list
    }
}

