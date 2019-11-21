//
//  SmoothViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/11/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class SmoothViewController: UIViewController {
    lazy var paging: JXPagingSmoothView = {
        return JXPagingSmoothView(dataSource: self)
    }()
    lazy var categoryView: JXCategoryTitleView = {
        return JXCategoryTitleView()
    }()
    lazy var headerView: UIImageView = {
        return UIImageView(image: UIImage(named: "lufei.jpg"))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        view.addSubview(paging)

        categoryView.titles = ["能力", "爱好", "队友"]
        categoryView.backgroundColor = .white
        categoryView.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        categoryView.titleColor = .black
        categoryView.isTitleColorGradientEnabled = true
        categoryView.isTitleLabelZoomEnabled = true
        categoryView.isContentScrollViewClickTransitionAnimationEnabled = false

        let line = JXCategoryIndicatorLineView()
        line.indicatorLineViewColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        line.indicatorLineWidth = 30
        categoryView.indicators = [line]

        headerView.contentMode = .scaleAspectFill

        categoryView.contentScrollView = paging.listCollectionView

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(didNaviRightItemClick))
    }

    @objc func didNaviRightItemClick() {
        categoryView.titles = ["第一", "第二", "第三"]
        categoryView.defaultSelectedIndex = 1
        paging.defaultSelectedIndex = 1
        categoryView.reloadData()
        paging.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        paging.frame = view.bounds
    }
}

extension SmoothViewController: JXPagingSmoothViewDataSource {
    func heightForPagingHeader(in pagingView: JXPagingSmoothView) -> CGFloat {
        return 300
    }

    func viewForPagingHeader(in pagingView: JXPagingSmoothView) -> UIView {
        return headerView
    }

    func heightForPinHeader(in pagingView: JXPagingSmoothView) -> CGFloat {
        return 50
    }

    func ViewForPinHeader(in pagingView: JXPagingSmoothView) -> UIView {
        return categoryView
    }

    func numberOfLists(in pagingView: JXPagingSmoothView) -> Int {
        return categoryView.titles.count
    }

    func pagingView(_ pagingView: JXPagingSmoothView, initListAtIndex index: Int) -> JXPagingSmoothViewListViewDelegate {
        let vc = SmoothListViewController()
        vc.title = categoryView.titles[index]
        return vc
    }
}
