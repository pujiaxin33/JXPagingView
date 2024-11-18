//
//  SwipeDeleteController.swift
//  JXPagingViewExample
//
//  Created by Ja on 2024/11/18.
//  Copyright © 2024 jiaxin. All rights reserved.
//

import JXPagingView

class SwipeDeleteController: BaseViewController {

    override func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        var dataSource = [String]()
        if index == 0 {
            dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮"]
        }else if index == 1 {
            dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
            return SwipeActionListViewController(dataSource: dataSource)
        }else {
            dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴"]
        }
        return SwipeListViewController(dataSource: dataSource)
    }
}
