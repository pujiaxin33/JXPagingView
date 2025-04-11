//
//  PagingNestPagingSubpageViewController.swift
//  JXPagingViewExample
//
//  Created by Jason on 2025/4/11.
//  Copyright © 2025 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView

class PagingNestPagingSubpageViewController: UIViewController, JXSegmentedViewDelegate {
    enum SubpageType: CaseIterable {
        case capability
        case hobby
        case partner
        
        var subtitles: [String] {
            switch self {
            case .capability:
                return ["进行型", "爆发型", "Buffer型"]
            case .hobby:
                return ["美食型", "搞笑型", "生活型"]
            case .partner:
                return ["原始人型", "果实能力型"]
            }
        }
    }
    let type: SubpageType
    
    var containerScrollViews: [UIScrollView] {
        return [pagingView.listContainerView.contentScrollView()]
    }
    weak var nestContentScrollView: UIScrollView?    //嵌套demo使用
    
    private lazy var titles = self.type.subtitles

    lazy var pagingView: JXPagingView = preferredPagingView()
    lazy var userHeaderView: PagingViewTableHeaderView = preferredTableHeaderView()
    let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    lazy var segmentedView: JXSegmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(headerInSectionHeight)))
    var tableHeaderViewHeight: Int = 200
    var headerInSectionHeight: Int = 50
    private var scrollCallback: ((UIScrollView) -> ())?
    
    init(type: SubpageType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.navigationController?.navigationBar.isTranslucent = false

        dataSource.titles = titles
        dataSource.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        dataSource.titleNormalColor = UIColor.black
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = true

        segmentedView.backgroundColor = UIColor.white
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.dataSource = dataSource
        segmentedView.delegate = self

        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorWidth = 30
        segmentedView.indicators = [lineView]

        let lineWidth = 1/UIScreen.main.scale
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.lightGray
        bottomLineView.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
        bottomLineView.autoresizingMask = .flexibleWidth
        segmentedView.addSubview(bottomLineView)

        pagingView.listContainerView.isCategoryNestPagingEnabled = true
        pagingView.mainTableView.gestureDelegate = self
        self.view.addSubview(pagingView)
        
        segmentedView.listContainer = pagingView.listContainerView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }

    func preferredTableHeaderView() -> PagingViewTableHeaderView {
        return PagingViewTableHeaderView()
    }

    func preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self, listContainerType: .scrollView)
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let list = ListViewController()
        list.title = titles[index]
        if index == 0 {
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if index == 1 {
            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else {
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        return list
    }

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
    }
}

extension PagingNestPagingSubpageViewController: JXPagingViewListViewDelegate {
    func listScrollView() -> UIScrollView {
        return pagingView.mainTableView
    }
    
    func listView() -> UIView {
        return self.view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        scrollCallback = callback
    }
    
    func listScrollViewWillResetContentOffset() {
        (Array(pagingView.listContainerView.validListDict.values) as? [ListViewController])?.forEach({ list in
            list.tableView.contentOffset = .zero
        })
        self.pagingView.mainTableView.contentOffset = .zero
    }
}

extension PagingNestPagingSubpageViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return tableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        scrollCallback?(scrollView)
    }
}

extension PagingNestPagingSubpageViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止Nest嵌套效果的时候，上下和左右都可以滚动
        if otherGestureRecognizer.view == nestContentScrollView {
            return false
        }
        //禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}
