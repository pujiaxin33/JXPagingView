//
//  JXSegmentedTitleOrImageCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedTitleOrImageCell: JXSegmentedTitleCell {
    public let imageView = UIImageView()
    private var currentImageInfo: String?

    open override func prepareForReuse() {
        super.prepareForReuse()

        currentImageInfo = nil
    }

    open override func commonInit() {
        super.commonInit()

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        imageView.center = contentView.center
    }

    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return
        }

        if myItemModel.isSelected && myItemModel.selectedImageInfo != nil {
            titleLabel.isHidden = true
            imageView.isHidden = false
        }else {
            titleLabel.isHidden = false
            imageView.isHidden = true
        }

        imageView.bounds = CGRect(x: 0, y: 0, width: myItemModel.imageSize.width, height: myItemModel.imageSize.height)

        //因为`func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType)`方法会回调多次，尤其是左右滚动的时候会调用无数次。如果每次都触发图片加载，会非常消耗性能。所以只会在图片发生了变化的时候，才进行图片加载。
        if myItemModel.isSelected &&
            myItemModel.selectedImageInfo != nil &&
            myItemModel.selectedImageInfo != currentImageInfo {
            currentImageInfo = myItemModel.selectedImageInfo
            if myItemModel.loadImageClosure != nil {
                myItemModel.loadImageClosure!(imageView, myItemModel.selectedImageInfo!)
            }else {
                imageView.image = UIImage(named: myItemModel.selectedImageInfo!)
            }
        }

        setNeedsLayout()
    }

    open override func preferredTitleZoomAnimateClosure(itemModel: JXSegmentedTitleItemModel, baseScale: CGFloat) -> JXSegmentedCellSelectedAnimationClosure {
        guard let myItemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return super.preferredTitleZoomAnimateClosure(itemModel: itemModel, baseScale: baseScale)
        }
        if myItemModel.selectedImageInfo == nil && myItemModel.isSelected {
            //当前item没有选中图片且是将要选中的时候才做动画
            return super.preferredTitleZoomAnimateClosure(itemModel: itemModel, baseScale: baseScale)
        }else {
            let closure: JXSegmentedCellSelectedAnimationClosure = {[weak self] (percent) in
                if itemModel.isSelected {
                    //将要选中
                    itemModel.titleCurrentZoomScale = itemModel.titleSelectedZoomScale
                }else {
                    //将要取消选中
                    itemModel.titleCurrentZoomScale = itemModel.titleNormalZoomScale
                }
                let currentTransform = CGAffineTransform(scaleX: baseScale*itemModel.titleCurrentZoomScale, y: baseScale*itemModel.titleCurrentZoomScale)
                self?.titleLabel.transform = currentTransform
                self?.maskTitleLabel.transform = currentTransform
            }
            //手动调用closure，更新到最新状态
            closure(0)
            return closure
        }
    }

    open override func preferredTitleStrokeWidthAnimateClosure(itemModel: JXSegmentedTitleItemModel, attriText: NSMutableAttributedString) -> JXSegmentedCellSelectedAnimationClosure {
        guard let myItemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return super.preferredTitleStrokeWidthAnimateClosure(itemModel: itemModel, attriText: attriText)
        }
        if myItemModel.selectedImageInfo == nil && myItemModel.isSelected {
            //当前item没有选中图片且是将要选中的时候才做动画
            return super.preferredTitleStrokeWidthAnimateClosure(itemModel: itemModel, attriText: attriText)
        }else {
            let closure: JXSegmentedCellSelectedAnimationClosure = {[weak self] (percent) in
                if itemModel.isSelected {
                    //将要选中
                    itemModel.titleCurrentStrokeWidth = itemModel.titleSelectedStrokeWidth
                }else {
                    //将要取消选中
                    itemModel.titleCurrentStrokeWidth = itemModel.titleNormalStrokeWidth
                }
                attriText.addAttributes([NSAttributedString.Key.strokeWidth: itemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: attriText.string.count))
                self?.titleLabel.attributedText = attriText
            }
            //手动调用closure，更新到最新状态
            closure(0)
            return closure
        }
    }

    open override func preferredTitleColorAnimateClosure(itemModel: JXSegmentedTitleItemModel) -> JXSegmentedCellSelectedAnimationClosure {
        guard let myItemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return super.preferredTitleColorAnimateClosure(itemModel: itemModel)
        }
        if myItemModel.selectedImageInfo == nil && myItemModel.isSelected {
            //当前item没有选中图片且是将要选中的时候才做动画
            return super.preferredTitleColorAnimateClosure(itemModel: itemModel)
        }else {
            let closure: JXSegmentedCellSelectedAnimationClosure = {[weak self] (percent) in
                if itemModel.isSelected {
                    //将要选中
                    itemModel.titleCurrentColor = itemModel.titleSelectedColor
                }else {
                    //将要取消选中
                    itemModel.titleCurrentColor = itemModel.titleNormalColor
                }
                self?.titleLabel.textColor = itemModel.titleCurrentColor
            }
            //手动调用closure，更新到最新状态
            closure(0)
            return closure
        }
    }
    
}
