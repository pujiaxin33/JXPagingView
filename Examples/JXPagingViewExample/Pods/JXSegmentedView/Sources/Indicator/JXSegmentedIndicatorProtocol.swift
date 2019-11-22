//
//  JXSegmentedIndicatorProtocol.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public protocol JXSegmentedIndicatorProtocol {
    /// 是否需要将当前的indicator的frame转换到cell。辅助JXSegmentedTitleDataSourced的isTitleMaskEnabled属性使用。
    /// 如果添加了多个indicator，仅能有一个indicator的isIndicatorConvertToItemFrameEnabled为true。
    /// 如果有多个indicator的isIndicatorConvertToItemFrameEnabled为true，则以最后一个isIndicatorConvertToItemFrameEnabled为true的indicator为准。
    var isIndicatorConvertToItemFrameEnabled: Bool { get }
    
    /// 视图重置状态时调用，已当前选中的index更新状态
    /// param selectedIndex 当前选中的index
    /// param selectedCellFrame 当前选中的cellFrame
    /// param contentSize collectionView的contentSize
    /// - Parameter model: model description
    func refreshIndicatorState(model: JXSegmentedIndicatorParamsModel)

    /// contentScrollView在进行手势滑动时，处理指示器跟随手势变化UI逻辑；
    /// param selectedIndex 当前选中的index
    /// param leftIndex 正在过渡中的两个cell，相对位置在左边的cell的index
    /// param leftCellFrame 正在过渡中的两个cell，相对位置在左边的cell的frame
    /// param rightIndex 正在过渡中的两个cell，相对位置在右边的cell的index
    /// param rightCellFrame 正在过渡中的两个cell，相对位置在右边的cell的frame
    /// param percent 过渡百分比
    /// - Parameter model: model description
    func contentScrollViewDidScroll(model: JXSegmentedIndicatorParamsModel)

    /// 点击选中了某一个item
    /// param lastSelectedIndex 之前选中的index
    /// param selectedIndex 选中的index
    /// param selectedCellFrame 选中的cellFrame
    /// param selectedType 选中的类型
    /// - Parameter model: model description
    func selectItem(model: JXSegmentedIndicatorParamsModel)
}
