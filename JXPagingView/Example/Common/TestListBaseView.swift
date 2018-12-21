//
//  TestListView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

@objc public class TestListBaseView: UIView {
    @objc public var tableView: UITableView!
    @objc public var dataSource: [String]?
    @objc public var isNeedHeader = false {
        didSet {
            if isNeedHeader {
                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
            }else if self.tableView.mj_header != nil {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_header.removeFromSuperview()
                self.tableView.mj_header = nil
            }
        }
    }
    @objc public var isNeedFooter = false {
        didSet {
            if isNeedFooter {
                tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
            }else if self.tableView.mj_footer != nil {
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_footer.removeFromSuperview()
                self.tableView.mj_footer = nil
            }
        }
    }
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    var lastSelectedIndexPath: IndexPath?
    var isHeaderRefreshed = false

    deinit {
        listViewDidScrollCallback = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TestTableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        addSubview(tableView)
    }

    func beginFirstRefresh() {
        if !isHeaderRefreshed {
            if (self.isNeedHeader) {
                self.tableView.mj_header.beginRefreshing()
                headerRefresh()
            }else {
                self.isHeaderRefreshed = true
                self.tableView.reloadData()
            }
        }
    }

    @objc func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
            self.tableView.mj_header.endRefreshing()
            self.isHeaderRefreshed = true
            self.tableView.reloadData()
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

    func selectedCell(at indexPath: IndexPath) {
        if lastSelectedIndexPath == indexPath {
            return
        }
        if lastSelectedIndexPath != nil {
            let cell = tableView.cellForRow(at: lastSelectedIndexPath!)
            cell?.setSelected(false, animated: false)
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(true, animated: false)
        lastSelectedIndexPath = indexPath
    }

}

extension TestListBaseView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHeaderRefreshed {
            return dataSource?.count ?? 0
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestTableViewCell
        cell.textLabel?.text = dataSource?[indexPath.row]
        cell.bgButtonClicked = {[weak self] in
            print("bgButtonClicked:\(indexPath)")
            self?.selectedCell(at: indexPath)
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

extension TestListBaseView: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return self
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.tableView
    }
}
