//
//  ViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/10.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var title: String?
        for view in cell!.contentView.subviews {
            if view.isKind(of: UILabel.self) {
                let label = view as! UILabel
                title = label.text
                break
            }
        }
        switch indexPath.row {
        case 0:
            let vc = ZoomViewController()
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = RefreshViewController()
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = ListRefreshViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = NaviHiddenViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = CollectionViewViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = VCViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = NestViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = HeightChangeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = HeightChangeAnimationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 9:
            let vc = HeaderPositionViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 10:
            let vc = SmoothViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 11:
            let vc = ListCacheViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 12:
            let vc = PagingNestCategoryExampleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 13:
            let vc = PagingNestTwoCategoryExampleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

}

