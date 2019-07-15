//
//  VCListViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/10/10.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class VCListViewController: UIViewController {
    let tableView: UITableView
    let dataSource: [String]
    var listViewDidScrollCallback: ((UIScrollView) -> ())?

    //如果使用UIViewController来封装逻辑，且要支持横竖屏切换，一定要加上下面这个方法。不加会有bug的。
    override func loadView() {
        self.view = UIView()
    }

    init(dataSource: [String]) {
        self.dataSource = dataSource
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TestTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

}

extension VCListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

extension VCListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }

    func listScrollView() -> UIScrollView {
        return tableView
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }
}
