//
//  JXSegmentedIndicatorBaseView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public enum JXSegmentedIndicatorPosition {
    case top
    case bottom
}

open class JXSegmentedIndicatorBaseView: UIView, JXSegmentedIndicatorProtocol {
    /// 默认JXSegmentedViewAutomaticDimension（与cell的宽度相等）。内部通过getIndicatorWidth方法获取实际的值
    open var indicatorWidth: CGFloat = JXSegmentedViewAutomaticDimension
    open var indicatorWidthIncrement: CGFloat = 0   //指示器的宽度增量。比如需求是指示器宽度比cell宽度多10 point。就可以将该属性赋值为10。最终指示器的宽度=indicatorWidth+indicatorWidthIncrement
    /// 默认JXSegmentedViewAutomaticDimension（与cell的高度相等）。内部通过getIndicatorHeight方法获取实际的值
    open var indicatorHeight: CGFloat = JXSegmentedViewAutomaticDimension
    /// 默认JXSegmentedViewAutomaticDimension （等于indicatorHeight/2）。内部通过getIndicatorCornerRadius方法获取实际的值
    open var indicatorCornerRadius: CGFloat = JXSegmentedViewAutomaticDimension
    /// 指示器的颜色
    open var indicatorColor: UIColor = .red
    /// 指示器的位置，top或者bottom
    open var indicatorPosition: JXSegmentedIndicatorPosition = .bottom
    /// 垂直方向偏移，指示器默认贴着底部或者顶部，verticalOffset越大越靠近中心。
    open var verticalOffset: CGFloat = 0
    /// 手势滚动、点击切换的时候，是否允许滚动。
    open var isScrollEnabled: Bool = true
    /// 是否需要将当前的indicator的frame转换到cell。辅助JXSegmentedTitleDataSourced的isTitleMaskEnabled属性使用。
    /// 如果添加了多个indicator，仅能有一个indicator的isIndicatorConvertToItemFrameEnabled为true。
    /// 如果有多个indicator的isIndicatorConvertToItemFrameEnabled为true，则以最后一个isIndicatorConvertToItemFrameEnabled为true的indicator为准。
    open var isIndicatorConvertToItemFrameEnabled: Bool = true
    /// 点击选中时的滚动动画时长
    open var scrollAnimationDuration: TimeInterval = 0.25

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

    public func getIndicatorCornerRadius(itemFrame: CGRect) -> CGFloat {
        if indicatorCornerRadius == JXSegmentedViewAutomaticDimension {
            return getIndicatorHeight(itemFrame: itemFrame)/2
        }
        return indicatorCornerRadius
    }

    public func getIndicatorWidth(itemFrame: CGRect) -> CGFloat {
        if indicatorWidth == JXSegmentedViewAutomaticDimension {
            return itemFrame.size.width + indicatorWidthIncrement
        }
        return indicatorWidth + indicatorWidthIncrement
    }

    public func getIndicatorHeight(itemFrame: CGRect) -> CGFloat {
        if indicatorHeight == JXSegmentedViewAutomaticDimension {
            return itemFrame.size.height
        }
        return indicatorHeight
    }

    //MARK: - JXSegmentedIndicatorProtocol
    open func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel) {
    }

    open func contentScrollViewDidScroll(model: JXSegmentedIndicatorParamsModel) {
    }

    open func selectItem(model: JXSegmentedIndicatorParamsModel) {
    }
}
