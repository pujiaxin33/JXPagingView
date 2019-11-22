//
//  JXSegmentedIndicatorGradientView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class JXSegmentedIndicatorGradientView: JXSegmentedIndicatorBaseView {
    /// 渐变colors
    open var gradientColors = [CGColor]()
    /// 宽度增量，背景指示器一般要比cell宽一些
    open var gradientViewWidthIncrement: CGFloat = 20
    /// 渐变CAGradientLayer，通过它设置startPoint、endPoint等其他属性
    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    public let gradientMaskLayer: CAShapeLayer = CAShapeLayer()
    open class override var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    private var gradientMaskLayerFrame = CGRect.zero

    open override func commonInit() {
        super.commonInit()

        indicatorHeight = 26

        gradientColors = [UIColor(red: 194.0/255, green: 229.0/255, blue: 156.0/255, alpha: 1).cgColor, UIColor(red: 100.0/255, green: 179.0/255, blue: 244.0/255, alpha: 1).cgColor]

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.mask = gradientMaskLayer
    }

    open override func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
        super.refreshIndicatorState(model: model)

        gradientLayer.colors = gradientColors

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        let height = getIndicatorHeight(itemFrame: model.currentSelectedItemFrame)
        let x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        let y = (model.currentSelectedItemFrame.size.height - height)/2
        gradientMaskLayerFrame = CGRect(x: x, y: y, width: width, height: height)
        let path = UIBezierPath(roundedRect: gradientMaskLayerFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientMaskLayer.path = path.cgPath
        CATransaction.commit()
        frame = CGRect(x: 0, y: 0, width: model.contentSize.width, height: model.contentSize.height)
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
        var targetWidth = getIndicatorWidth(itemFrame: leftItemFrame)

        let leftWidth = targetWidth
        let rightWidth = getIndicatorWidth(itemFrame: rightItemFrame)
        let leftX = leftItemFrame.origin.x + (leftItemFrame.size.width - leftWidth)/2
        let rightX = rightItemFrame.origin.x + (rightItemFrame.size.width - rightWidth)/2
        let targetX = JXSegmentedViewTool.interpolate(from: leftX, to: rightX, percent: CGFloat(percent))
        if indicatorWidth == JXSegmentedViewAutomaticDimension {
            targetWidth = JXSegmentedViewTool.interpolate(from: leftWidth, to: rightWidth, percent: CGFloat(percent))
        }

        gradientMaskLayerFrame.origin.x = targetX
        gradientMaskLayerFrame.size.width = targetWidth
        let path = UIBezierPath(roundedRect: gradientMaskLayerFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: leftItemFrame))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientMaskLayer.path = path.cgPath
        CATransaction.commit()
    }

    open override func selectItem(model: JXSegmentedIndicatorParamsModel) {
        super.selectItem(model: model)

        let width = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame)
        var toFrame = gradientMaskLayerFrame
        toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - width)/2
        toFrame.size.width = width
        let path = UIBezierPath(roundedRect: toFrame, cornerRadius: getIndicatorCornerRadius(itemFrame: model.currentSelectedItemFrame))
        if isScrollEnabled && (model.selectedType == .click || model.selectedType == .code) {
            //允许滚动且选中类型是点击或代码选中，才进行动画过渡
            gradientMaskLayer.removeAnimation(forKey: "path")
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = gradientMaskLayer.path
            animation.toValue = path.cgPath
            animation.duration = scrollAnimationDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            gradientMaskLayer.add(animation, forKey: "path")
            gradientMaskLayer.path = path.cgPath
        }else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientMaskLayer.path = path.cgPath
            CATransaction.commit()
        }
    }

    open override func getIndicatorWidth(itemFrame: CGRect) -> CGFloat {
        return super.getIndicatorWidth(itemFrame: itemFrame) + gradientViewWidthIncrement
    }
}
