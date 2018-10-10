//
//  ListRefreshViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class ListRefreshViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for listView in listViewArray {
            (listView as! TestListBaseView).isNeedHeader = true
        }
    }

    override func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }


}
