//
//  JXSegmentedIndicatorDoubleLineView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedIndicatorDoubleLineView: JXSegmentedIndicatorBaseView {
    /// 线收缩到最小的百分比
    open var minLineWidthPercent: CGFloat = 0.2
    public let selectedLineView: UIView = UIView()
    public let otherLineView: UIView = UIView()

    open override func commonInit() {
        super.commonInit()

        indicatorHeight = 3

        addSubview(selectedLineView)

        otherLineView.alpha = 0
        addSubview(otherLineView)
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
        super.refreshIndicatorState(model: model)

        selectedLineView.backgroundColor = indicatorColor
        otherLineView.backgroundColor = indicatorColor
        selectedLineView.layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)
        otherLineView.layer.cornerRadius = getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        var y = model.currentSelectedItemFrame.size.height - height - verticalOffset
        if indicatorPosition == .top {
            y = verticalOffset
        }
        selectedLineView.frame = CGRect(x: x, y: y, width: width, height: height)
        otherLineView.frame = selectedLineView.frame
    }

    open override func contentScrollViewDidScroll(model: JXSegmentedIndicatorParamsModel) {
        super.contentScrollViewDidScroll(model: model)

        if model.percent == 0 || !isScrollEnabled {
            //model.percent等于0时不需要处理，会调用selectItem(model: JXSegmentedIndicatorParamsModel)方法处理
            //isScrollEnabled为false不需要处理
            return
        }

        let rightItemFrame = model.rightItemFrame
        let leftItemFrame = model.leftItemFrame
        let percent = model.percent

        let leftCenter = getCenter(in: leftItemFrame)
        let rightCenter = getCenter(in: rightItemFrame)
        let leftMaxWidth = getIndicatorWidth(itemFrame: leftItemFrame)
        let rightMaxWidth = getIndicatorWidth(itemFrame: rightItemFrame)
        let leftMinWidth = leftMaxWidth*minLineWidthPercent
        let rightMinWidth = rightMaxWidth*minLineWidthPercent

        let leftWidth: CGFloat = JXSegmentedViewTool.interpolate(from: leftMaxWidth, to: leftMinWidth, percent: CGFloat(percent))
        let rightWidth: CGFloat = JXSegmentedViewTool.interpolate(from: rightMinWidth, to: rightMaxWidth, percent: CGFloat(percent))
        let leftAlpha: CGFloat = JXSegmentedViewTool.interpolate(from: 1, to: 0, percent: CGFloat(percent))
        let rightAlpha: CGFloat = JXSegmentedViewTool.interpolate(from: 0, to: 1, percent: CGFloat(percent))

        if model.currentSelectedIndex == model.leftIndex {
            selectedLineView.bounds.size.width = leftWidth
            selectedLineView.center = leftCenter
            selectedLineView.alpha = leftAlpha

            otherLineView.bounds.size.width = rightWidth
            otherLineView.center = rightCenter
            otherLineView.alpha = rightAlpha
        }else {
            otherLineView.bounds.size.width = leftWidth
            otherLineView.center = leftCenter
            otherLineView.alpha = leftAlpha

            selectedLineView.bounds.size.width = rightWidth
            selectedLineView.center = rightCenter
            selectedLineView.alpha = rightAlpha
        }
    }

    open override func selectItem(model: JXSegmentedIndicatorParamsModel) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        let targetCenter = getCenter(in: model.currentSelectedItemFrame)
        selectedLineView.bounds.size.width = targetWidth
        selectedLineView.center = targetCenter
        selectedLineView.alpha = 1

        otherLineView.alpha = 0
    }

    private func getCenter(in frame: CGRect) -> CGPoint {
        return CGPoint(x: frame.midX, y: selectedLineView.center.y)
    }
}
