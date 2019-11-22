//
//  JXSegmentedNumberCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedNumberCell: JXSegmentedTitleCell {
    public let numberLabel = UILabel()

    open override func commonInit() {
        super.commonInit()

        numberLabel.isHidden = true
        numberLabel.textAlignment = .center
        numberLabel.layer.masksToBounds = true
        contentView.addSubview(numberLabel)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? JXSegmentedNumberItemModel else {
            return
        }

        numberLabel.sizeToFit()
        let height = myItemModel.numberHeight
        numberLabel.layer.cornerRadius = height/2
        numberLabel.bounds.size = CGSize(width: numberLabel.bounds.size.width + myItemModel.numberWidthIncrement, height: height)
        numberLabel.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.numberOffset.x, y: titleLabel.frame.minY + myItemModel.numberOffset.y)
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedNumberItemModel else {
            return
        }

        numberLabel.backgroundColor = myItemModel.numberBackgroundColor
        numberLabel.textColor = myItemModel.numberTextColor
        numberLabel.text = myItemModel.numberString
        numberLabel.font = myItemModel.numberFont
        numberLabel.isHidden = myItemModel.number == 0

        setNeedsLayout()
    }
}
