//
//  BaseViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/10.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {
    var pagingView: JXPagingView!
    var userHeaderView: PagingViewTableHeaderView!
    var userHeaderContainerView: UIView!
    var categoryView: JXCategoryTitleView!
    var titles = ["能力", "爱好", "队友"]
    weak var nestContentScrollView: UIScrollView?    //嵌套demo使用
    var JXTableHeaderViewHeight: Int = 200
    var JXheightForHeaderInSection: Int = 50
    var isNeedHeader = false
    var isNeedFooter = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.navigationController?.navigationBar.isTranslucent = false
        
        userHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXTableHeaderViewHeight)))
        userHeaderView = PagingViewTableHeaderView(frame: userHeaderContainerView.bounds)
        userHeaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        userHeaderContainerView.addSubview(userHeaderView)

        categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXheightForHeaderInSection)))
        categoryView.titles = titles
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        categoryView.titleColor = UIColor.black
        categoryView.isTitleColorGradientEnabled = true
        categoryView.isTitleLabelZoomEnabled = true
        categoryView.delegate = self

        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorLineViewColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorLineWidth = 30
        categoryView.indicators = [lineView]

        let lineWidth = 1/UIScreen.main.scale
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.lightGray
        bottomLineView.frame = CGRect(x: 0, y: categoryView.bounds.height - lineWidth, width: categoryView.bounds.width, height: lineWidth)
        bottomLineView.autoresizingMask = .flexibleWidth
        categoryView.addSubview(bottomLineView)

        pagingView = preferredPagingView()
        pagingView.mainTableView.gestureDelegate = self

        self.view.addSubview(pagingView)
        
        categoryView.contentScrollView = pagingView.listContainerView.collectionView

        //扣边返回处理，下面的代码要加上
        pagingView.listContainerView.collectionView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (categoryView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

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

extension BaseViewController: JXPagingViewDelegate {

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
        let list = TestListBaseView()
        list.naviController = self.navigationController
        list.isNeedHeader = isNeedHeader
        list.isNeedFooter = isNeedFooter
        if index == 0 {
            list.dataSource = ["橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮", "橡胶火箭", "橡胶火箭炮", "橡胶机关枪", "橡胶子弹", "橡胶攻城炮", "橡胶象枪", "橡胶象枪乱打", "橡胶灰熊铳", "橡胶雷神象枪", "橡胶猿王枪", "橡胶犀·榴弹炮", "橡胶大蛇炮"]
        }else if index == 1 {
            list.dataSource = ["吃烤肉", "吃鸡腿肉", "吃牛肉", "各种肉"]
        }else {
            list.dataSource = ["【剑士】罗罗诺亚·索隆", "【航海士】娜美", "【狙击手】乌索普", "【厨师】香吉士", "【船医】托尼托尼·乔巴", "【船匠】 弗兰奇", "【音乐家】布鲁克", "【考古学家】妮可·罗宾"]
        }
        list.beginFirstRefresh()
        return list
    }
}

extension BaseViewController: JXCategoryViewDelegate {
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }

    func categoryView(_ categoryView: JXCategoryBaseView!, didClickedItemContentScrollViewTransitionTo index: Int){
        //请务必实现该方法
        //因为底层触发列表加载是在代理方法：`- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath`回调里面
        //所以，如果当前有5个item，当前在第1个，用于点击了第5个。categoryView默认是通过设置contentOffset.x滚动到指定的位置，这个时候有个问题，就会触发中间2、3、4的cellForItemAtIndexPath方法。
        //如此一来就丧失了延迟加载的功能
        //所以，如果你想规避这样的情况发生，那么务必按照这里的方法处理滚动。
        self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)


        //如果你想相邻的两个item切换时，通过有动画滚动实现。未相邻的两个item直接切换，可以用下面这段代码
        /*
        let diffIndex = abs(categoryView.selectedIndex - index)
        if diffIndex > 1 {
            self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        }else {
            self.pagingView.listContainerView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
        */
    }
}

extension BaseViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止Nest嵌套效果的时候，上下和左右都可以滚动
        if otherGestureRecognizer.view == nestContentScrollView {
            return false
        }
        //禁止categoryView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == categoryView?.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder())
    }
}
