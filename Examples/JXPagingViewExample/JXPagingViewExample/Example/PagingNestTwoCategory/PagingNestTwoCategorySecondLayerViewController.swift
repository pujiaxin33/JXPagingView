//
//  PagingNestTwoCategorySecondLayerViewController.swift
//  JXPagingViewExample
//
//  Created by Jason on 2025/3/14.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class PagingNestTwoCategorySecondLayerViewController: UIViewController {
    weak var refreshDelegate: ListViewControllerHeaderAndFooterRefreshEventProtocol?
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    var containerScrollView: UIScrollView {
        return listContainer.scrollView
    }
    var currentListView: UIScrollView?
    
    var titleDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView()
    lazy var listContainer = JXSegmentedListContainerView(dataSource: self, type: .scrollView)

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["二级一", "二级二", "二级三"]
        titleDataSource.titles = titles
        titleDataSource.itemSpacing = 0
        titleDataSource.itemContentWidth = 80
        titleDataSource.titleNormalColor = .black
        titleDataSource.titleSelectedColor = .white
        titleDataSource.isTitleMaskEnabled = true

        segmentedView.contentEdgeInsetLeft = 15
        segmentedView.contentEdgeInsetRight = 15
        segmentedView.dataSource = titleDataSource
        segmentedView.delegate = self

        let indicatoryView = JXSegmentedIndicatorBackgroundView()
        indicatoryView.indicatorColor = .red
        indicatoryView.indicatorWidth = 80
        indicatoryView.indicatorHeight = 30
        indicatoryView.indicatorWidthIncrement = 0
        indicatoryView.backgroundWidthIncrement = 0
        segmentedView.indicators = [indicatoryView]

        view.addSubview(segmentedView)
        view.addSubview(listContainer)

        segmentedView.listContainer = listContainer
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = .init(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainer.frame = .init(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }
    
    func headerRefresh() {
        guard let currentList = self.listContainer.validListDict[self.segmentedView.selectedIndex] as? ListViewController else {
            return
        }
        
        currentList.mockHeaderRefreshLoadNewData()
    }
    
    func listScrollViewWillResetContentOffset() {
        (Array(listContainer.validListDict.values) as? [ListViewController])?.forEach({ list in
            list.listScrollViewWillResetContentOffset()
        })
    }
}

extension PagingNestTwoCategorySecondLayerViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}

extension PagingNestTwoCategorySecondLayerViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return titleDataSource.titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let list = ListViewController()
        if index == 0 {
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if index == 1 {
            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else {
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        list.listViewDidScrollCallback = { [weak self] (scrollView) in
            self?.listViewDidScrollCallback?(scrollView)
        }
        currentListView = list.tableView
        list.refreshDelegate = refreshDelegate
        return list
    }
}

extension PagingNestTwoCategorySecondLayerViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        let list = self.listContainer.validListDict[index] as? ListViewController
        self.currentListView = list?.tableView
    }
}
