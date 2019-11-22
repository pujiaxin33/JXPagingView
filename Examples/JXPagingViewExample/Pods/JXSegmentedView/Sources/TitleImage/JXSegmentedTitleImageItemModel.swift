//
//  JXSegmentedTitleImageItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleImageItemModel: JXSegmentedTitleItemModel {
    open var titleImageType: JXSegmentedTitleImageType = .rightImage
    open var normalImageInfo: String?
    open var selectedImageInfo: String?
    open var loadImageClosure: LoadImageClosure?
    open var imageSize: CGSize = CGSize.zero
    open var titleImageSpacing: CGFloat = 0
    open var isImageZoomEnabled: Bool = false
    open var imageNormalZoomScale: CGFloat = 0
    open var imageCurrentZoomScale: CGFloat = 0
    open var imageSelectedZoomScale: CGFloat = 0
}
