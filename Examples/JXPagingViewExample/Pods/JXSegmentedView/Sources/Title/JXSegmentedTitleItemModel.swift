//
//  JXSegmentedTitleItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleItemModel: JXSegmentedBaseItemModel {
    open var title: String?
    open var titleNumberOfLines: Int = 0
    open var titleNormalColor: UIColor = .black
    open var titleCurrentColor: UIColor = .black
    open var titleSelectedColor: UIColor = .red
    open var titleNormalFont: UIFont = UIFont.systemFont(ofSize: 15)
    open var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    open var isTitleZoomEnabled: Bool = false
    open var titleNormalZoomScale: CGFloat = 0
    open var titleCurrentZoomScale: CGFloat = 0
    open var titleSelectedZoomScale: CGFloat = 0
    open var isTitleStrokeWidthEnabled: Bool = false
    open var titleNormalStrokeWidth: CGFloat = 0
    open var titleCurrentStrokeWidth: CGFloat = 0
    open var titleSelectedStrokeWidth: CGFloat = 0
    open var isTitleMaskEnabled: Bool = false
    open var textWidth: CGFloat = 0
}
