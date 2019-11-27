//
//  SmoothViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/11/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView
import MJRefresh

class SmoothViewController: UIViewController {
    lazy var paging: JXPagingSmoothView = {
        return JXPagingSmoothView(dataSource: self)
    }()
    lazy var segmentedView: JXSegmentedView = {
        return JXSegmentedView()
    }()
    lazy var headerView: UIImageView = {
        return UIImageView(image: UIImage(named: "lufei.jpg"))
    }()
    let dataSource = JXSegmentedTitleDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        view.addSubview(paging)

        dataSource.titles = ["能力", "爱好", "队友"]
        dataSource.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        dataSource.titleNormalColor = UIColor.black
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isTitleZoomEnabled = true

        segmentedView.backgroundColor = .white
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.delegate = self
        segmentedView.dataSource = dataSource

        let line = JXSegmentedIndicatorLineView()
        line.indicatorColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        line.indicatorWidth = 30
        segmentedView.indicators = [line]

        headerView.clipsToBounds = true
        headerView.contentMode = .scaleAspectFill

        segmentedView.contentScrollView = paging.listCollectionView

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reload", style: .plain, target: self, action: #selector(didNaviRightItemClick))
        paging.listCollectionView.panGestureRecognizer.require(toFail: navigationController!.interactivePopGestureRecognizer!)
    }

    @objc func didNaviRightItemClick() {
        dataSource.titles = ["第一", "第二", "第三"]
        dataSource.reloadData(selectedIndex: 1)
        segmentedView.defaultSelectedIndex = 1
        paging.defaultSelectedIndex = 1
        segmentedView.reloadData()
        paging.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        paging.frame = view.bounds
    }
}

extension SmoothViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
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

    func viewForPinHeader(in pagingView: JXPagingSmoothView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingSmoothView) -> Int {
        return dataSource.titles.count
    }

    func pagingView(_ pagingView: JXPagingSmoothView, initListAtIndex index: Int) -> JXPagingSmoothViewListViewDelegate {
        let vc = SmoothListViewController()
        vc.delegate = self
        vc.title = dataSource.titles[index]
        return vc
    }
}

extension SmoothViewController: SmoothListViewControllerDelegate {
    func startRefresh() {
        paging.listCollectionView.isScrollEnabled = false
        segmentedView.isUserInteractionEnabled = false
    }

    func endRefresh() {
        paging.listCollectionView.isScrollEnabled = true
        segmentedView.isUserInteractionEnabled = true
    }
}
