//
//  JXSegmentedBaseItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

open class JXSegmentedBaseItemModel {
    open var index: Int = 0
    open var isSelected: Bool = false
    open var itemWidth: CGFloat = 0
    /// 指示器视图Frame转换到cell
    open var indicatorConvertToItemFrame: CGRect = CGRect.zero
    open var isItemTransitionEnabled: Bool = true
    open var isSelectedAnimable: Bool = false
    open var selectedAnimationDuration: TimeInterval = 0
    /// 是否正在进行过渡动画
    open var isTransitionAnimating: Bool = false
    open var isItemWidthZoomEnabled: Bool = false
    open var itemWidthNormalZoomScale: CGFloat = 0
    open var itemWidthCurrentZoomScale: CGFloat = 0
    open var itemWidthSelectedZoomScale: CGFloat = 0

    public init() {
    }
}
