//
//  NestViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/11/2.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class NestViewController: UIViewController {
    var naviDataSource = JXSegmentedTitleDataSource()
    var naviSegmentedView: JXSegmentedView!
    var contentScrollView: UIScrollView!
    var pagingVCArray = [BaseViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["主题一", "主题二"]
        naviDataSource.titles = titles
        naviDataSource.itemSpacing = 0
        naviDataSource.itemContentWidth = 80
        naviDataSource.titleNormalColor = .black
        naviDataSource.titleSelectedColor = .white
        naviDataSource.isTitleMaskEnabled = true

        naviSegmentedView = JXSegmentedView()
        naviSegmentedView.contentEdgeInsetLeft = 0
        naviSegmentedView.contentEdgeInsetRight = 0
        naviSegmentedView.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        naviSegmentedView.dataSource = naviDataSource

        let indicatoryView = JXSegmentedIndicatorBackgroundView()
        indicatoryView.indicatorColor = .red
        indicatoryView.indicatorWidth = 80
        indicatoryView.indicatorHeight = 30
        indicatoryView.indicatorWidthIncrement = 0
        indicatoryView.backgroundWidthIncrement = 0
        naviSegmentedView.indicators = [indicatoryView]

        navigationItem.titleView = naviSegmentedView

        contentScrollView = UIScrollView()
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        for _ in 0..<titles.count {
            let pagingVC = BaseViewController()
            pagingVC.nestContentScrollView = contentScrollView
            addChild(pagingVC)
            contentScrollView.addSubview(pagingVC.view)
            pagingVCArray.append(pagingVC)
        }
        view.addSubview(contentScrollView)

        naviSegmentedView.contentScrollView = contentScrollView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentScrollView.frame = view.bounds
        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(naviDataSource.titles.count), height: contentScrollView.bounds.size.height)
        contentScrollView.contentOffset.x = CGFloat(naviSegmentedView.selectedIndex)*contentScrollView.bounds.size.width
        for (index, vc) in pagingVCArray.enumerated() {
            vc.view.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
            vc.pagingView.listContainerView.collectionView.isNestEnabled = true
        }
    }

}
