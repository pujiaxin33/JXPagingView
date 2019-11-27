//
//  SmoothListViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/11/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import MJRefresh

class SmoothListViewController: UIViewController, JXPagingSmoothViewListViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        return UITableView(frame: CGRect.zero, style: .plain)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header.ignoredScrollViewContentInsetTop = 350
    }

    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.tableView.mj_header.endRefreshing()
            //TODO:每个列表的下拉刷新事件，需要同时交给SmoothViewController类进行顶部header的刷新
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(title ?? ""):\(indexPath.row)"
        return cell
    }

    func listView() -> UIView {
        return view
    }

    func listScrollView() -> UIScrollView {
        return tableView
    }
}
