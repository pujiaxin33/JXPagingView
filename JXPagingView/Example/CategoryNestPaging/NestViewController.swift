//
//  NestViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/11/2.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class NestViewController: UIViewController {
    var naviCategoryView: JXCategoryTitleView!
    var contentScrollView: UIScrollView!
    var pagingVCArray = [BaseViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let titles = ["主题一", "主题二"]
        naviCategoryView = JXCategoryTitleView()
        naviCategoryView.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        naviCategoryView.titles = titles
        naviCategoryView.cellSpacing = 0
        naviCategoryView.cellWidth = 80
        naviCategoryView.titleColor = .black
        naviCategoryView.titleSelectedColor = .white
        naviCategoryView.isTitleLabelMaskEnabled = true

        let indicatoryView = JXCategoryIndicatorBackgroundView()
        indicatoryView.backgroundViewColor = .red
        indicatoryView.backgroundViewWidth = 80
        indicatoryView.backgroundViewHeight = 30
        indicatoryView.backgroundViewWidthIncrement = 0
        naviCategoryView.indicators = [indicatoryView]

        navigationItem.titleView = naviCategoryView

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

        naviCategoryView.contentScrollView = contentScrollView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentScrollView.frame = view.bounds
        contentScrollView.contentSize = CGSize(width: contentScrollView.bounds.size.width*CGFloat(naviCategoryView.titles.count), height: contentScrollView.bounds.size.height)
        contentScrollView.contentOffset.x = CGFloat(naviCategoryView.selectedIndex)*contentScrollView.bounds.size.width
        for (index, vc) in pagingVCArray.enumerated() {
            vc.view.frame = CGRect(x: contentScrollView.bounds.size.width*CGFloat(index), y: 0, width: contentScrollView.bounds.size.width, height: contentScrollView.bounds.size.height)
            vc.pagingView.listContainerView.collectionView.isNestEnabled = true
        }
    }

}
