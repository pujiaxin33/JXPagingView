//
//  JXSegmentedTitleImageDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public enum JXSegmentedTitleImageType {
    case topImage
    case leftImage
    case bottomImage
    case rightImage
    case onlyImage
    case onlyTitle
}

public typealias LoadImageClosure = ((UIImageView, String) -> Void)

open class JXSegmentedTitleImageDataSource: JXSegmentedTitleDataSource {
    open var titleImageType: JXSegmentedTitleImageType = .rightImage
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片网络地址
    open var normalImageInfos: [String]?
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片网络地址。如果不赋值，选中时就不会处理图片切换。
    open var selectedImageInfos: [String]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片网络地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    open var loadImageClosure: LoadImageClosure?
    /// 图片尺寸
    open var imageSize: CGSize = CGSize(width: 20, height: 20)
    /// title和image之间的间隔
    open var titleImageSpacing: CGFloat = 5
    /// 是否开启图片缩放
    open var isImageZoomEnabled: Bool = false
    /// 图片缩放选中时的scale
    open var imageSelectedZoomScale: CGFloat = 1.2

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleImageItemModel()
    }

    open override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        itemModel.titleImageType = titleImageType
        itemModel.normalImageInfo = normalImageInfos?[index]
        itemModel.selectedImageInfo = selectedImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
        itemModel.isImageZoomEnabled = isImageZoomEnabled
        itemModel.imageNormalZoomScale = 1
        itemModel.imageSelectedZoomScale = imageSelectedZoomScale
        itemModel.titleImageSpacing = titleImageSpacing
        if index == selectedIndex {
            itemModel.imageCurrentZoomScale = itemModel.imageSelectedZoomScale
        }else {
            itemModel.imageCurrentZoomScale = itemModel.imageNormalZoomScale
        }
    }

    open override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var itemWidth = super.preferredSegmentedView(segmentedView, widthForItemAt: index)
        if itemContentWidth == JXSegmentedViewAutomaticDimension {
            switch titleImageType {
            case .leftImage, .rightImage:
                itemWidth += titleImageSpacing + imageSize.width
            case .topImage, .bottomImage:
                itemWidth = max(itemWidth, imageSize.width)
            case .onlyImage:
                itemWidth = imageSize.width
            case .onlyTitle:
                break
            }
        }
        return itemWidth
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    open override func refreshItemModel(_ segmentedView: JXSegmentedView, leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let leftModel = leftItemModel as? JXSegmentedTitleImageItemModel, let rightModel = rightItemModel as? JXSegmentedTitleImageItemModel else {
            return
        }
        if isImageZoomEnabled && isItemTransitionEnabled {
            leftModel.imageCurrentZoomScale = JXSegmentedViewTool.interpolate(from: imageSelectedZoomScale, to: 1, percent: CGFloat(percent))
            rightModel.imageCurrentZoomScale = JXSegmentedViewTool.interpolate(from: 1, to: imageSelectedZoomScale, percent: CGFloat(percent))
        }
    }

    open override func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleImageItemModel, let myWillSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        myCurrentSelectedItemModel.imageCurrentZoomScale = myCurrentSelectedItemModel.imageNormalZoomScale
        myWillSelectedItemModel.imageCurrentZoomScale = myWillSelectedItemModel.imageSelectedZoomScale
    }
}
