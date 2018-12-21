//
//  VCListViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/10/10.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class VCListViewController: UIViewController {
    var contentView = TestListBaseView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(contentView)
        contentView.beginFirstRefresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentView.frame = view.bounds
    }

}

extension VCListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }

    func listScrollView() -> UIScrollView {
        return contentView.tableView
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        contentView.listViewDidScrollCallback = callback
    }
}
