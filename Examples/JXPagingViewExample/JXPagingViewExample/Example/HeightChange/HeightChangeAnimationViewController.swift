//
//  HeightChangeAnimationViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/7/8.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class HeightChangeAnimationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func preferredTableHeaderView() -> PagingViewTableHeaderView {
        tableHeaderViewHeight = 80
        let header = HeightChangeAnimationTableHeaderView()
        header.toggleCallback = { (isSelected) in
            self.changeTableHeaderViewHeight()
        }
        return header
    }

    @objc func changeTableHeaderViewHeight() {
        //改变tableHeaderViewHeight的值
        if tableHeaderViewHeight == 250 {
            //先更新`func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int`方法用到的变量
            tableHeaderViewHeight = 80
            //再调用resizeTableHeaderViewHeight方法
            pagingView.resizeTableHeaderViewHeight(animatable: true)
        }else {
            tableHeaderViewHeight = 250
            pagingView.resizeTableHeaderViewHeight(animatable: true)
        }
    }

}
