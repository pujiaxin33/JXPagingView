//
//  JXSegmentedDotCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedDotCell: JXSegmentedTitleCell {
    open var dotView = UIView()

    open override func commonInit() {
        super.commonInit()

        contentView.addSubview(dotView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? JXSegmentedDotItemModel else {
            return
        }

        dotView.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.dotOffset.x, y: titleLabel.frame.minY + myItemModel.dotOffset.y)
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedDotItemModel else {
            return
        }

        dotView.backgroundColor = myItemModel.dotColor
        dotView.bounds = CGRect(x: 0, y: 0, width: myItemModel.dotSize.width, height: myItemModel.dotSize.height)
        dotView.isHidden = !myItemModel.dotState
        dotView.layer.cornerRadius = myItemModel.dotCornerRadius
    }
}
