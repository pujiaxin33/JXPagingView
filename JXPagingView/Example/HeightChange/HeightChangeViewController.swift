//
//  HeightChangeViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/11/14.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class HeightChangeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "高度", style: .plain, target: self, action: #selector(didNaviRightItemClicked))
    }

    @objc func didNaviRightItemClicked() {
        //改变JXTableHeaderViewHeight的值
        JXTableHeaderViewHeight = 100
        //改变headerView相关view的高度
        userHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: CGFloat(JXTableHeaderViewHeight))
        //因为内部imageView需要支持下拉方法效果，所以这里用一种比较恶心的方式更新imageView.frame。你自己的headerView根据实际情况更新frame哈
        userHeaderView.imageView.frame = userHeaderView.bounds
        //调用reloadData方法
        pagingView.resizeTableHeaderViewHeight(CGFloat(JXTableHeaderViewHeight))
    }
}
