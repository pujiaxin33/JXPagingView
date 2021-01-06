//
//  ZoomViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView

class ZoomViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        userHeaderView.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}
