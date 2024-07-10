//
//  BaseNavigationController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactivePopGestureRecognizer?.delegate = self
        
        if #available(iOS 13.0, *) {
            // iOS15 系统下 push 后导航条变黑色 且 有卡顿
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = .white
            self.navigationBar.scrollEdgeAppearance = barAppearance
            self.navigationBar.standardAppearance = barAppearance;
        }
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
        }
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
