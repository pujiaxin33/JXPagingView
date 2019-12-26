//
//  JXPagingViewMainTableView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

@objc public protocol JXPagingMainTableViewGestureDelegate {
    //如果headerView（或其他地方）有水平滚动的scrollView，当其正在左右滑动的时候，就不能让列表上下滑动，所以有此代理方法进行对应处理
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

open class JXPagingMainTableView: UITableView, UIGestureRecognizerDelegate {
    public weak var gestureDelegate: JXPagingMainTableViewGestureDelegate?

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureDelegate != nil {
            return gestureDelegate!.mainTableViewGestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith:otherGestureRecognizer)
        }else {
            return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        }
    }
}
