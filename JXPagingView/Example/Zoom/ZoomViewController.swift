//
//  ZoomViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

fileprivate let JXTableHeaderViewHeight: CGFloat = 200
fileprivate let JXHeightForHeaderOfSection: CGFloat = 50

class ZoomViewController: UIViewController {
    var pagingView: JXPagingViewView!
    var userHeaderView: PagingViewTableHeaderView!
    var categoryView: JXCategoryView!
    var listViewArray: [TestListBaseView]!
    var titles = ["能力", "爱好", "队友"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.navigationController?.navigationBar.isTranslucent = false

        let powerListView = PowerListView()
        powerListView.delegate = self

        let hobbyListView = HobbyListView()
        hobbyListView.delegate = self

        let partnerListView = PartnerListView()
        partnerListView.delegate = self

        listViewArray = [powerListView, hobbyListView, partnerListView]

        userHeaderView = PagingViewTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: JXTableHeaderViewHeight))

        categoryView = JXCategoryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: JXHeightForHeaderOfSection))
        categoryView.titles = titles
        categoryView.indicatorLineWidth = 30
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        categoryView.indicatorLineColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        categoryView.titleColor = UIColor.black

        let lineWidth = 1/UIScreen.main.scale
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        lineLayer.frame = CGRect(x: 0, y: categoryView.bounds.height - lineWidth, width: categoryView.bounds.width, height: lineWidth)
        categoryView.layer.addSublayer(lineLayer)

        pagingView = JXPagingViewView(delegate: self)
        pagingView.delegate = self
        self.view.addSubview(pagingView)

        categoryView.contentScrollView = pagingView.listContainerView.collectionView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }

}

extension ZoomViewController: JXPagingViewDelegate {

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        userHeaderView?.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }

    func tableHeaderViewHeight(in pagingView: JXPagingViewView) -> CGFloat {
        return JXTableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingViewView) -> UIView {
        return userHeaderView
    }

    func heightForHeaderOfSection(in pagingView: JXPagingViewView) -> CGFloat {
        return JXHeightForHeaderOfSection
    }

    func viewForHeaderOfSection(in pagingView: JXPagingViewView) -> UIView {
        return categoryView
    }

    func numberOfListViews(in pagingView: JXPagingViewView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingViewView, listViewInRow row: Int) -> UIView & JXPagingViewListViewDelegate {
        return listViewArray[row]
    }
}

extension ZoomViewController: TestListViewDelegate {
    func listViewDidScroll(_ scrollView: UIScrollView) {
        pagingView.listViewDidScroll(scrollView: scrollView)
    }
}
