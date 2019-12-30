//
//  NestSubjectViewController.swift
//  JXPagingViewExample
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXSegmentedView

class NestSubjectViewController: BaseViewController, JXSegmentedListContainerViewListDelegate {
    weak var nestContentScrollView: UIScrollView?    //嵌套demo使用

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止Nest嵌套效果的时候，上下和左右都可以滚动
        if otherGestureRecognizer.view == nestContentScrollView {
            return false
        }
        return super.mainTableViewGestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer)
    }

    func listView() -> UIView {
        return view
    }
}
