//
//  TestListView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

@objc public protocol TestListViewDelegate {
    func listViewDidScroll(_ scrollView: UIScrollView)
}

@objc public class TestListBaseView: UIView {
    @objc public var tableView: UITableView!
    @objc public var dataSource: [String]?
    @objc public var isNeedHeader = false
    @objc public var isNeedFooter = false
    @objc public weak var delegate: TestListViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        addSubview(tableView)
    }

    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.tableView.mj_header.endRefreshing()
        }
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if newSuperview != nil {
            if isNeedHeader {
                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
            }
            if isNeedFooter {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = self.bounds
    }

    @objc func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.dataSource?.append("加载更多成功")
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
        }
    }

}

extension TestListBaseView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource?[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.listViewDidScroll(scrollView)
    }
}

extension TestListBaseView: JXPagingViewListViewDelegate {
    public func listScrollView() -> UIScrollView {
        return self.tableView
    }
}
