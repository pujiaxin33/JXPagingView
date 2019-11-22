//
//  ListRefreshViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView

class ListRefreshViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNeedHeader = true
    }

    override func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }


}
