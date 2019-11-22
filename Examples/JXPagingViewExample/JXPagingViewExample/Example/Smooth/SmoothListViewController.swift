//
//  SmoothListViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/11/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView

class SmoothListViewController: UIViewController, JXPagingSmoothViewListViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        return UITableView(frame: CGRect.zero, style: .plain)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
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
