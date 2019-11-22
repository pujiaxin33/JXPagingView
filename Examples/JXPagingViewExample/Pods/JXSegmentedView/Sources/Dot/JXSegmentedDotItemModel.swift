//
//  JXSegmentedDotItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedDotItemModel: JXSegmentedTitleItemModel {
    open var dotState = false
    open var dotSize = CGSize.zero
    open var dotCornerRadius: CGFloat = 0
    open var dotColor = UIColor.red
    open var dotOffset: CGPoint = CGPoint.zero
}
