//
//  JXSegmentedBaseCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public typealias JXSegmentedCellSelectedAnimationClosure = (CGFloat)->()

open class JXSegmentedBaseCell: UICollectionViewCell {
    open var itemModel: JXSegmentedBaseItemModel?
    open var animator: JXSegmentedAnimator?
    private var selectedAnimationClosureArray = [JXSegmentedCellSelectedAnimationClosure]()

    deinit {
        animator?.stop()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        animator?.stop()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    open func commonInit() {
        
    }

    open func canStartSelectedAnimation(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) -> Bool {
        var isSelectedAnimatable = false
        if itemModel.isSelectedAnimable {
            if selectedType == .scroll {
                //滚动选中且没有开启左右过渡，允许动画
                if !itemModel.isItemTransitionEnabled {
                    isSelectedAnimatable = true
                }
            }else if selectedType == .click || selectedType == .code {
                //点击和代码选中，允许动画
                isSelectedAnimatable = true
            }
        }
        return isSelectedAnimatable
    }

    open func appendSelectedAnimationClosure(closure: @escaping JXSegmentedCellSelectedAnimationClosure) {
        selectedAnimationClosureArray.append(closure)
    }

    open func startSelectedAnimationIfNeeded(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        if itemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
            //需要更新isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
            itemModel.isTransitionAnimating = true
            animator?.progressClosure = {[weak self] (percent) in
                guard self != nil else {
                    return
                }
                for closure in self!.selectedAnimationClosureArray {
                    closure(percent)
                }
            }
            animator?.completedClosure = {[weak self] in
                itemModel.isTransitionAnimating = false
                self?.selectedAnimationClosureArray.removeAll()
            }
            animator?.start()
        }
    }

    open func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        self.itemModel = itemModel

        if itemModel.isSelectedAnimable {
            selectedAnimationClosureArray.removeAll()
            if canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                animator = JXSegmentedAnimator()
                animator?.duration = itemModel.selectedAnimationDuration
            }else {
                animator?.stop()
            }
        }
    }
}
