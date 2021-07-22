//
//  SmoothListRefreshViewController.swift
//  SmoothListRefreshViewController
//
//  Created by Amiee on 2021/7/21.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView
import MJRefresh

class SmoothListRefreshViewController: UIViewController, JXPagingSmoothViewListViewDelegate, UITableViewDataSource {
    var count = 100
    lazy var tableView: UITableView = {
        return UITableView(frame: CGRect.zero, style: .plain)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow() {
        NSLog("keyboardWillShow")
    }
    
    func keyboardWillShowWithNotification(_ notification: Notification) {
        NSLog("keyboardWillShow")
    }
    
    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.tableView.mj_header?.endRefreshing()
        }
    }
    
    @objc func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.count += 100
            self.tableView.reloadData()
            self.tableView.mj_footer?.endRefreshing()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
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
