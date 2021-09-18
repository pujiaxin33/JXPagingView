//
//  SmoothRefreshViewController.swift
//  SmoothRefreshViewController
//
//  Created by Amiee on 2021/7/21.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView
import MJRefresh

class SmoothRefreshViewController: UIViewController {
    lazy var paging: JXPagingSmoothView = {
        return JXPagingSmoothView(dataSource: self, pagingHeaderBounces: false)
    }()
    lazy var segmentedView: JXSegmentedView = {
        return JXSegmentedView()
    }()
    lazy var headerView: UIImageView = {
        return UIImageView(image: UIImage(named: "lufei.jpg"))
    }()
    let dataSource = JXSegmentedTitleDataSource()
    var headerHeight: CGFloat = 300
    
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
        paging.pinSectionHeaderVerticalOffset = -25
        
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        textField.backgroundColor = .red
        headerView.isUserInteractionEnabled = true
        headerView.addSubview(textField)
    }
    
    @objc func didNaviRightItemClick() {
        dataSource.titles = ["第一", "第二", "第三"]
        dataSource.reloadData(selectedIndex: 1)
        segmentedView.defaultSelectedIndex = 1
        paging.defaultSelectedIndex = 1
        segmentedView.reloadData()
        paging.reloadData()
        
        headerHeight = 200
        paging.resizePagingTopHeight(animatable: true, duration: 0.25, options: .curveEaseInOut)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        paging.frame = view.bounds
    }
}

extension SmoothRefreshViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

extension SmoothRefreshViewController: JXPagingSmoothViewDataSource {
    func heightForPagingHeader(in pagingView: JXPagingSmoothView) -> CGFloat {
        return headerHeight
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
        let vc = SmoothListRefreshViewController()
        vc.title = dataSource.titles[index]
        return vc
    }
}
