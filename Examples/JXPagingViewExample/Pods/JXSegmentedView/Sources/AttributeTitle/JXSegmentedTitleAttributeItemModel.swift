//
//  JXSegmentedTitleAttributeItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/3.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleAttributeItemModel: JXSegmentedBaseItemModel {
    open var attributedTitle: NSAttributedString?
    open var selectedAttributedTitle: NSAttributedString?
    open var titleNumberOfLines: Int = 0
    open var textWidth: CGFloat = 0
}
