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
        if tableHeaderViewHeight == 200 {
            //先更新`func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int`方法用到的变量
            tableHeaderViewHeight = 100
            //再调用resizeTableHeaderViewHeight方法
            pagingView.resizeTableHeaderViewHeight()
        }else {
            tableHeaderViewHeight = 200
            pagingView.resizeTableHeaderViewHeight()
        }
    }
}
