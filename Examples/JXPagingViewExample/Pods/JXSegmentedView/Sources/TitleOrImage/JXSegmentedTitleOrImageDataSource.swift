//
//  JXSegmentedTitleOrImageDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleOrImageDataSource: JXSegmentedTitleDataSource {
    /// 数量需要和item的数量保持一致。可以是ImageName或者图片地址。选中时不显示图片就填nil
    open var selectedImageInfos: [String?]?
    /// 内部默认通过UIImage(named:)加载图片。如果传递的是图片地址或者想自己处理图片加载逻辑，可以通过该闭包处理。
    open var loadImageClosure: LoadImageClosure?
    /// 图片尺寸
    open var imageSize: CGSize = CGSize(width: 30, height: 30)

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleOrImageItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        selectedAnimationDuration = 0.1

        super.reloadData(selectedIndex: selectedIndex)
    }

    open override func preferredRefreshItemModel( _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return
        }

        itemModel.selectedImageInfo = selectedImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedTitleOrImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
