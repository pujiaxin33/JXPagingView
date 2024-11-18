//
//  SwipeActionListViewController.swift
//  JXPagingViewExample
//
//  Created by Ja on 2024/11/18.
//  Copyright © 2024 jiaxin. All rights reserved.
//

import JXPagingView

class SwipeActionListViewController: UIViewController {
    
    lazy var tableView: SwipeTableView = {
        let tv = SwipeTableView(frame: CGRect.zero, style: .plain)
        tv.parentController = self
        return tv
    }()

    var dataSource: [String]

    //如果使用UIViewController来封装逻辑，且要支持横竖屏切换，一定要加上下面这个方法。不加会有bug的。
    override func loadView() {
        self.view = UIView()
    }

    init(dataSource: [String]) {
        self.dataSource = dataSource
        
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
        tableView.register(SwipeActionCell.self, forCellReuseIdentifier: "cell")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

}

extension SwipeActionListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SwipeActionCell ?? SwipeActionCell()
        cell.delegate = self
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "删除") {  _, _, completionHandler in
            
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension SwipeActionListViewController: SwipeActionCellDelegate {
    func swipeCellAction(in cell: SwipeActionCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("点击了 ---- section: \(indexPath.section) ==== row: \(indexPath.row)")
        }
    }
}

extension SwipeActionListViewController: JXPagingViewListViewDelegate {
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}
