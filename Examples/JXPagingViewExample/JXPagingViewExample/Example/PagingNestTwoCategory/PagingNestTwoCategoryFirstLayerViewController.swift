//
//  PagingNestTwoCategoryFirstLayerViewController.swift
//  JXPagingViewExample
//
//  Created by Jason on 2025/3/14.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView
import JXPagingView

class PagingNestTwoCategoryFirstLayerViewController: UIViewController {
    weak var refreshDelegate: ListViewControllerHeaderAndFooterRefreshEventProtocol?
    
    var containerScrollViews: [UIScrollView] {
        let listArray = Array(listContainer.validListDict.values) as? [PagingNestTwoCategorySecondLayerViewController]
        let listScrollViewArray = listArray?.map { $0.containerScrollView } ?? []
        return [listContainer.scrollView] + listScrollViewArray
    }
    
    var titleDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView = JXSegmentedView()
    lazy var listContainer = JXSegmentedListContainerView(dataSource: self, type: .scrollView)

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["第一级一", "第一级二", "第一级三", "第一级四", "第一级五"]
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
        guard let currentList = self.listContainer.validListDict[self.segmentedView.selectedIndex] as? PagingNestTwoCategorySecondLayerViewController else {
            return
        }
        
        currentList.headerRefresh()
    }
}

extension PagingNestTwoCategoryFirstLayerViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        let currentListVC = listContainer.validListDict[segmentedView.selectedIndex] as? PagingNestTwoCategorySecondLayerViewController
        return currentListVC?.currentListView ?? UIScrollView()
    }

    func listScrollViewWillResetContentOffset() {
        (Array(listContainer.validListDict.values) as? [PagingNestTwoCategorySecondLayerViewController])?.forEach({ list in
            list.listScrollViewWillResetContentOffset()
        })
    }
}


extension PagingNestTwoCategoryFirstLayerViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return titleDataSource.titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let list = PagingNestTwoCategorySecondLayerViewController()
        list.listViewDidScrollCallback = { [weak self] (scrollView) in
            self?.listViewDidScrollCallback?(scrollView)
        }
        list.refreshDelegate = refreshDelegate
        return list
    }
}

extension PagingNestTwoCategoryFirstLayerViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
    }
}
