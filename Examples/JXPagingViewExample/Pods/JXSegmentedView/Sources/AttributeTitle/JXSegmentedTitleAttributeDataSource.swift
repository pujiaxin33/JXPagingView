//
//  JXSegmentedTitleAttributeDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleAttributeDataSource: JXSegmentedBaseDataSource {
    /// 富文本title数组
    open var attributedTitles = [NSAttributedString]()
    /// 选中时的富文本，可选。如果要使用确保count与attributedTitles一致。
    open var selectedAttributedTitles: [NSAttributedString]?
    /// 如果将JXSegmentedView嵌套进UITableView的cell，每次重用的时候，JXSegmentedView进行reloadData时，会重新计算所有的title宽度。所以该应用场景，需要UITableView的cellModel缓存titles的文字宽度，再通过该闭包方法返回给JXSegmentedView。
    open var widthForTitleClosure: ((NSAttributedString)->(CGFloat))?
    /// title的numberOfLines
    open var titleNumberOfLines: Int = 2

    deinit {
        widthForTitleClosure = nil
    }

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleAttributeItemModel()
    }

    open override func reloadData(selectedIndex: Int) {
        super.reloadData(selectedIndex: selectedIndex)

        for index in 0..<attributedTitles.count {
            let itemModel = preferredItemModelInstance() as! JXSegmentedTitleAttributeItemModel
            preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)
            dataSource.append(itemModel)
        }
    }

    open override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let myItemModel = itemModel as? JXSegmentedTitleAttributeItemModel else {
            return
        }

        myItemModel.attributedTitle = attributedTitles[index]
        myItemModel.selectedAttributedTitle = selectedAttributedTitles?[index]
        myItemModel.textWidth = widthForItem(title: myItemModel.attributedTitle, selectedTitle: myItemModel.selectedAttributedTitle)
        myItemModel.titleNumberOfLines = titleNumberOfLines
    }

    open func widthForItem(title: NSAttributedString?, selectedTitle: NSAttributedString?) -> CGFloat {
        let attriText = selectedTitle != nil ? selectedTitle : title
        guard let text = attriText else {
            return 0
        }
        if widthForTitleClosure != nil {
            return widthForTitleClosure!(text)
        }else {
            let textWidth = text.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil).size.width
            return CGFloat(ceilf(Float(textWidth)))
        }
    }

    /// 因为该方法会被频繁调用，所以应该在`preferredRefreshItemModel( _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int)`方法里面，根据数据源计算好文字宽度，然后缓存起来。该方法直接使用已经计算好的文字宽度即可。
    open override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var itemWidth: CGFloat = 0
        if itemContentWidth == JXSegmentedViewAutomaticDimension {
            let myItemModel = dataSource[index] as! JXSegmentedTitleAttributeItemModel
            itemWidth = myItemModel.textWidth + itemWidthIncrement
        }else {
            itemWidth = itemContentWidth + itemWidthIncrement
        }
        return itemWidth
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedTitleAttributeCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
