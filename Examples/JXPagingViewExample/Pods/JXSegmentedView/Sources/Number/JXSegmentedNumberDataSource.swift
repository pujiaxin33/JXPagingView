//
//  JXSegmentedNumberDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

open class JXSegmentedNumberDataSource: JXSegmentedTitleDataSource {
    /// 需要和titles数组数量一致，没有数字的item填0！！！
    open var numbers = [Int]()
    /// numberLabel的宽度补偿，numberLabel真实的宽度是文字内容的宽度加上补偿的宽度
    open var numberWidthIncrement: CGFloat = 10
    /// numberLabel的背景色
    open var numberBackgroundColor: UIColor = .red
    /// numberLabel的textColor
    open var numberTextColor: UIColor = .white
    /// numberLabel的font
    open var numberFont: UIFont = UIFont.systemFont(ofSize: 11)
    /// numberLabel的默认位置是center在titleLabel的右上角，可以通过numberOffset控制X、Y轴的偏移
    open var numberOffset: CGPoint = CGPoint.zero
    /// 如果业务需要处理超过999就像是999+，就可以通过这个闭包实现。默认显示不会对number进行处理
    open var numberStringFormatterClosure: ((Int) -> String)?
    /// numberLabel的高度，默认：14
    open var numberHeight: CGFloat = 14
    
    deinit {
        numberStringFormatterClosure = nil
    }

    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedNumberItemModel()
    }

    open override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedNumberItemModel else {
            return
        }

        itemModel.number = numbers[index]
        if numberStringFormatterClosure != nil {
            itemModel.numberString = numberStringFormatterClosure!(itemModel.number)
        }else {
            itemModel.numberString = "\(itemModel.number)"
        }
        itemModel.numberTextColor = numberTextColor
        itemModel.numberBackgroundColor = numberBackgroundColor
        itemModel.numberOffset = numberOffset
        itemModel.numberWidthIncrement = numberWidthIncrement
        itemModel.numberHeight = numberHeight
    }

    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedNumberCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
