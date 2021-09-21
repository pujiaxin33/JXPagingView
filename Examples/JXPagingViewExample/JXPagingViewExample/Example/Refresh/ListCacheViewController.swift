//
//  ListCacheViewController.swift
//  JXPagingViewExample
//
//  Created by jiaxin on 2021/7/1.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView

class ListCacheViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        pagingView.allowsCacheList = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(refreshList))
    }

    @objc func refreshList() {
        titles = ["爱好", "队友", "其他"]
        dataSource.titles = titles
        segmentedView.reloadData()
        pagingView.reloadData()
    }

    func pagingView(_ pagingView: JXPagingView, listIdentifierAtIndex index: Int) -> String {
        return titles[index]
    }

    override func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        //使用allowsCacheList，初始化list，需要先根据index获取listIdentifier，再根据listIdentifier初始化对应的list
        let listIdentifier = titles[index]
        let list = ListViewController()
        list.title = titles[index]
        list.isNeedHeader = isNeedHeader
        list.isNeedFooter = isNeedFooter
        if listIdentifier == "能力" {
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if listIdentifier == "爱好" {
            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else if listIdentifier == "队友" {
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }else if listIdentifier == "其他" {
            list.dataSource = ["其他数据1", "其他数据2", "其他数据3", "其他数据4", "其他数据5"]
        }
        return list
    }
}
