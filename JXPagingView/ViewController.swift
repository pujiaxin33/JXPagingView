//
//  ViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/10.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
        let zoomVC = ZoomViewController()
        self.navigationController?.pushViewController(zoomVC, animated: true)
        }else if indexPath.row == 1 {
            let refreshVC = RefreshViewController()
            self.navigationController?.pushViewController(refreshVC, animated: true)
        }
    }

}

