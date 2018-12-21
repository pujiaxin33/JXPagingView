//
//  CollectionViewViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/10/9.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit


class CollectionViewViewController: UIViewController {
    var pagingView: JXPagingView!
    var userHeaderView: PagingViewTableHeaderView!
    var userHeaderContainerView: UIView!
    var categoryView: JXCategoryTitleView!
    var titles = ["能力", "爱好", "队友"]
    var JXTableHeaderViewHeight: Int = 200
    var JXheightForHeaderInSection: Int = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CollectionView列表示例"
        self.navigationController?.navigationBar.isTranslucent = false

        userHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXTableHeaderViewHeight)))
        userHeaderView = PagingViewTableHeaderView(frame: userHeaderContainerView.bounds)
        userHeaderContainerView.addSubview(userHeaderView)

        categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXheightForHeaderInSection)))
        categoryView.titles = titles
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        categoryView.titleColor = UIColor.black
        categoryView.titleColorGradientEnabled = true
        categoryView.titleLabelZoomEnabled = true
        categoryView.delegate = self

        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorLineViewColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorLineWidth = 30
        categoryView.indicators = [lineView]

        let lineWidth = 1/UIScreen.main.scale
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        lineLayer.frame = CGRect(x: 0, y: categoryView.bounds.height - lineWidth, width: categoryView.bounds.width, height: lineWidth)
        categoryView.layer.addSublayer(lineLayer)

        pagingView = preferredPagingView()
        self.view.addSubview(pagingView)

        categoryView.contentScrollView = pagingView.listContainerView.collectionView

        //扣边返回处理，下面的代码要加上
        pagingView.listContainerView.collectionView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }

    func preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self)
    }

}

extension CollectionViewViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderContainerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return JXheightForHeaderInSection
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return categoryView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return TestListCollectionView()
    }
}

extension CollectionViewViewController: JXCategoryViewDelegate {
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

