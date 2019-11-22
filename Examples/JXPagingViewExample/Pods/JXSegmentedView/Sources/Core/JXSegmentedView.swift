//
//  JXSegmentedView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

public let JXSegmentedViewAutomaticDimension: CGFloat = -1

/// 选中item时的类型
///
/// - unknown: 不是选中
/// - code: 通过代码调用方法`func selectItemAt(index: Int)`选中
/// - click: 通过点击item选中
/// - scroll: 通过滚动到item选中
public enum JXSegmentedViewItemSelectedType {
    case unknown
    case code
    case click
    case scroll
}

public protocol JXSegmentedViewListContainer {
    var defaultSelectedIndex: Int { set get }
    func contentScrollView() -> UIScrollView
    func reloadData()
    func scrolling(from leftIndex: Int, to rightIndex: Int, percent: CGFloat, selectedIndex: Int)
    func didClickSelectedItem(at index: Int)
}

public protocol JXSegmentedViewDataSource: AnyObject {
    var isItemWidthZoomEnabled: Bool { get }
    var selectedAnimationDuration: TimeInterval { get }
    var itemSpacing: CGFloat { get }
    var isItemSpacingAverageEnabled: Bool { get }

    func reloadData(selectedIndex: Int)

    /// 返回数据源数组，数组元素必须是JXSegmentedBaseItemModel及其子类
    ///
    /// - Parameter segmentedView: JXSegmentedView
    /// - Returns: 数据源数组
    func itemDataSource(in segmentedView: JXSegmentedView) -> [JXSegmentedBaseItemModel]

    /// 返回index对应item的宽度。
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 目标index
    ///   - isItemWidthZoomValid: 计算的宽度是否需要受isItemWidthZoomEnabled影响
    /// - Returns: item的宽度
    func segmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int, isItemWidthZoomValid: Bool) -> CGFloat

    /// 注册cell class
    ///
    /// - Parameter segmentedView: JXSegmentedView
    func registerCellClass(in segmentedView: JXSegmentedView)

    /// 返回index对应的cell
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 目标index
    /// - Returns: JXSegmentedBaseCell及其子类
    func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell

    /// 根据当前选中的selectedIndex，刷新目标index的itemModel
    ///
    /// - Parameters:
    ///   - itemModel: JXSegmentedBaseItemModel
    ///   - index: 目标index
    ///   - selectedIndex: 当前选中的index
    func refreshItemModel(_ segmentedView: JXSegmentedView, _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int)

    /// item选中的时候调用。当前选中的currentSelectedItemModel状态需要更新为未选中；将要选中的willSelectedItemModel状态需要更新为选中。
    ///
    /// - Parameters:
    ///   - currentSelectedItemModel: 当前选中的itemModel
    ///   - willSelectedItemModel: 将要选中的itemModel
    ///   - selectedType: 选中的类型
    func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType)

    /// 左右滚动过渡时调用。根据当前的从左到右的百分比，刷新leftItemModel和rightItemModel
    ///
    /// - Parameters:
    ///   - leftItemModel: 相对位置在左边的itemModel
    ///   - rightItemModel: 相对位置在右边的itemModel
    ///   - percent: 从左到右的百分比
    func refreshItemModel(_ segmentedView: JXSegmentedView, leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat)
}

/// 为什么会把选中代理分为三个，因为有时候只关心点击选中的，有时候只关心滚动选中的，有时候只关心选中。所以具体情况，使用对应方法。
public protocol JXSegmentedViewDelegate: AnyObject {
    /// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int)

    /// 点击选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int)

    /// 滚动选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int)

    /// 正在滚动中的回调
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - leftIndex: 正在滚动中，相对位置处于左边的index
    ///   - rightIndex: 正在滚动中，相对位置处于右边的index
    ///   - percent: 从左往右计算的百分比
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat)


    /// 是否允许点击选中目标index的item
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 目标index
    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool
}

/// 提供JXSegmentedViewDelegate的默认实现，这样对于遵从JXSegmentedViewDelegate的类来说，所有代理方法都是可选实现的。
public extension JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) { }
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) { }
    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool { return true }
}

/// 内部会自己找到父UIViewController，然后将其automaticallyAdjustsScrollViewInsets设置为false，这一点请知晓。
open class JXSegmentedView: UIView {
    open weak var dataSource: JXSegmentedViewDataSource? {
        didSet {
            dataSource?.reloadData(selectedIndex: selectedIndex)
        }
    }
    open weak var delegate: JXSegmentedViewDelegate?
    open private(set) var collectionView: JXSegmentedCollectionView!
    open var contentScrollView: UIScrollView? {
        willSet {
            contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
        }
        didSet {
            contentScrollView?.scrollsToTop = false
            contentScrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    public var listContainer: JXSegmentedViewListContainer? = nil {
        didSet {
            listContainer?.defaultSelectedIndex = defaultSelectedIndex
            contentScrollView = listContainer?.contentScrollView()
        }
    }
    /// indicators的元素必须是遵从JXSegmentedIndicatorProtocol协议的UIView及其子类
    open var indicators = [JXSegmentedIndicatorProtocol & UIView]() {
        didSet {
            collectionView.indicators = indicators
        }
    }
    /// 初始化或者reloadData之前设置，用于指定默认的index
    open var defaultSelectedIndex: Int = 0 {
        didSet {
            selectedIndex = defaultSelectedIndex
            if listContainer != nil {
                listContainer?.defaultSelectedIndex = defaultSelectedIndex
            }
        }
    }
    open private(set) var selectedIndex: Int = 0
    /// 整体内容的左边距，默认JXSegmentedViewAutomaticDimension（等于itemSpacing）
    open var contentEdgeInsetLeft: CGFloat = JXSegmentedViewAutomaticDimension
    /// 整体内容的右边距，默认JXSegmentedViewAutomaticDimension（等于itemSpacing）
    open var contentEdgeInsetRight: CGFloat = JXSegmentedViewAutomaticDimension
    /// 点击切换的时候，contentScrollView的切换是否需要动画
    open var isContentScrollViewClickTransitionAnimationEnabled: Bool = true

    private var itemDataSource = [JXSegmentedBaseItemModel]()
    private var innerItemSpacing: CGFloat = 0
    private var lastContentOffset: CGPoint = CGPoint.zero
    /// 正在滚动中的目标index。用于处理正在滚动列表的时候，立即点击item，会导致界面显示异常。
    private var scrollingTargetIndex: Int = -1
    private var isFirstLayoutSubviews = true

    deinit {
        contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = JXSegmentedCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        if #available(iOS 10.0, *) {
            collectionView.isPrefetchingEnabled = false
        }
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        addSubview(collectionView)
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        var nextResponder: UIResponder? = newSuperview
        while nextResponder != nil {
            if let parentVC = nextResponder as? UIViewController  {
                parentVC.automaticallyAdjustsScrollViewInsets = false
                break
            }
            nextResponder = nextResponder?.next
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        //部分使用者为了适配不同的手机屏幕尺寸，JXSegmentedView的宽高比要求保持一样。所以它的高度就会因为不同宽度的屏幕而不一样。计算出来的高度，有时候会是位数很长的浮点数，如果把这个高度设置给UICollectionView就会触发内部的一个错误。所以，为了规避这个问题，在这里对高度统一向下取整。
        //如果向下取整导致了你的页面异常，请自己重新设置JXSegmentedView的高度，保证为整数即可。
        let targetFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height: floor(bounds.size.height))
        if isFirstLayoutSubviews {
            isFirstLayoutSubviews = false
            collectionView.frame = targetFrame
            reloadDataWithoutListContainer()
        }else {
            if collectionView.frame != targetFrame {
                collectionView.frame = targetFrame
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
            }
        }
    }

    //MARK: - Public
    public final func dequeueReusableCell(withReuseIdentifier identifier: String, at index: Int) -> JXSegmentedBaseCell {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard cell.isKind(of: JXSegmentedBaseCell.self) else {
            fatalError("Cell class must be subclass of JXSegmentedBaseCell")
        }
        return cell as! JXSegmentedBaseCell
    }

    open func reloadData() {
        reloadDataWithoutListContainer()
        listContainer?.reloadData()
    }

    open func reloadDataWithoutListContainer() {
        dataSource?.reloadData(selectedIndex: selectedIndex)
        dataSource?.registerCellClass(in: self)
        if let itemSource = dataSource?.itemDataSource(in: self) {
            itemDataSource = itemSource
        }
        if selectedIndex < 0 || selectedIndex >= itemDataSource.count {
            defaultSelectedIndex = 0
            selectedIndex = 0
        }

        innerItemSpacing = dataSource?.itemSpacing ?? 0
        var totalItemWidth: CGFloat = 0
        var totalContentWidth: CGFloat = getContentEdgeInsetLeft()
        for (index, itemModel) in itemDataSource.enumerated() {
            itemModel.index = index
            itemModel.itemWidth = (dataSource?.segmentedView(self, widthForItemAt: index, isItemWidthZoomValid: true) ?? 0)
            itemModel.isSelected = (index == selectedIndex)
            totalItemWidth += itemModel.itemWidth
            if index == itemDataSource.count - 1 {
                totalContentWidth += itemModel.itemWidth + getContentEdgeInsetRight()
            }else {
                totalContentWidth += itemModel.itemWidth + innerItemSpacing
            }
        }

        if dataSource?.isItemSpacingAverageEnabled == true && totalContentWidth < bounds.size.width {
            var itemSpacingCount = itemDataSource.count - 1
            var totalItemSpacingWidth = bounds.size.width - totalItemWidth
            if contentEdgeInsetLeft == JXSegmentedViewAutomaticDimension {
                itemSpacingCount += 1
            }else {
                totalItemSpacingWidth -= contentEdgeInsetLeft
            }
            if contentEdgeInsetRight == JXSegmentedViewAutomaticDimension {
                itemSpacingCount += 1
            }else {
                totalItemSpacingWidth -= contentEdgeInsetRight
            }
            if itemSpacingCount > 0 {
                innerItemSpacing = totalItemSpacingWidth / CGFloat(itemSpacingCount)
            }
        }

        var selectedItemFrameX = innerItemSpacing
        var selectedItemWidth: CGFloat = 0
        totalContentWidth = getContentEdgeInsetLeft()
        for (index, itemModel) in itemDataSource.enumerated() {
            if index < selectedIndex {
                selectedItemFrameX += itemModel.itemWidth + innerItemSpacing
            }else if index == selectedIndex {
                selectedItemWidth = itemModel.itemWidth
            }
            if index == itemDataSource.count - 1 {
                totalContentWidth += itemModel.itemWidth + getContentEdgeInsetRight()
            }else {
                totalContentWidth += itemModel.itemWidth + innerItemSpacing
            }
        }

        let minX: CGFloat = 0
        let maxX = totalContentWidth - bounds.size.width
        let targetX = selectedItemFrameX - bounds.size.width/2 + selectedItemWidth/2
        collectionView.setContentOffset(CGPoint(x: max(min(maxX, targetX), minX), y: 0), animated: false)

        if contentScrollView != nil {
            if contentScrollView!.frame.equalTo(CGRect.zero) &&
                contentScrollView!.superview != nil {
                //某些情况系统会出现JXSegmentedView先布局，contentScrollView后布局。就会导致下面指定defaultSelectedIndex失效，所以发现contentScrollView的frame为zero时，强行触发其父视图链里面已经有frame的一个父视图的layoutSubviews方法。
                //比如JXSegmentedListContainerView会将contentScrollView包裹起来使用，该情况需要JXSegmentedListContainerView.superView触发布局更新
                var parentView = contentScrollView?.superview
                while parentView != nil && parentView?.frame.equalTo(CGRect.zero) == true {
                    parentView = parentView?.superview
                }
                parentView?.setNeedsLayout()
                parentView?.layoutIfNeeded()
            }

            contentScrollView!.setContentOffset(CGPoint(x: CGFloat(selectedIndex) * contentScrollView!.bounds.size.width
                , y: 0), animated: false)
        }

        for indicator in indicators {
            if itemDataSource.isEmpty {
                indicator.isHidden = true
            }else {
                indicator.isHidden = false
                let indicatorParamsModel = JXSegmentedIndicatorParamsModel()
                indicatorParamsModel.contentSize = CGSize(width: totalContentWidth, height: bounds.size.height)
                indicatorParamsModel.currentSelectedIndex = selectedIndex
                let selectedItemFrame = getItemFrameAt(index: selectedIndex)
                indicatorParamsModel.currentSelectedItemFrame = selectedItemFrame
                indicator.refreshIndicatorState(model: indicatorParamsModel)

                if indicator.isIndicatorConvertToItemFrameEnabled {
                    var indicatorConvertToItemFrame = indicator.frame
                    indicatorConvertToItemFrame.origin.x -= selectedItemFrame.origin.x
                    itemDataSource[selectedIndex].indicatorConvertToItemFrame = indicatorConvertToItemFrame
                }
            }
        }
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    open func reloadItem(at index: Int) {
        guard index >= 0 && index < itemDataSource.count else {
            return
        }

        dataSource?.refreshItemModel(self, itemDataSource[index], at: index, selectedIndex: selectedIndex)
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? JXSegmentedBaseCell
        cell?.reloadData(itemModel: itemDataSource[index], selectedType: .unknown)
    }


    /// 代码选中指定index
    /// 如果要同时触发列表容器对应index的列表加载，请再调用`listContainerView.didClickSelectedItem(at: index)`方法
    ///
    /// - Parameter index: 目标index
    open func selectItemAt(index: Int) {
        selectItemAt(index: index, selectedType: .code)
    }

    //MARK: - KVO
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let contentOffset = change?[NSKeyValueChangeKey.newKey] as! CGPoint
            if contentScrollView?.isTracking == true || contentScrollView?.isDecelerating == true {
                //用户滚动引起的contentOffset变化，才处理。
                var progress = contentOffset.x/contentScrollView!.bounds.size.width
                if Int(progress) > itemDataSource.count - 1 || progress < 0 {
                    //超过了边界，不需要处理
                    return
                }
                if contentOffset.x == 0 && selectedIndex == 0 && lastContentOffset.x == 0 {
                    //滚动到了最左边，且已经选中了第一个，且之前的contentOffset.x为0
                    return
                }
                let maxContentOffsetX = contentScrollView!.contentSize.width - contentScrollView!.bounds.size.width
                if contentOffset.x == maxContentOffsetX && selectedIndex == itemDataSource.count - 1 && lastContentOffset.x == maxContentOffsetX {
                    //滚动到了最右边，且已经选中了最后一个，且之前的contentOffset.x为maxContentOffsetX
                    return
                }

                progress = max(0, min(CGFloat(itemDataSource.count - 1), progress))
                let baseIndex = Int(floor(progress))
                let remainderProgress = progress - CGFloat(baseIndex)

                let leftItemFrame = getItemFrameAt(index: baseIndex)
                let rightItemFrame = getItemFrameAt(index: baseIndex + 1)

                let indicatorParamsModel = JXSegmentedIndicatorParamsModel()
                indicatorParamsModel.currentSelectedIndex = selectedIndex
                indicatorParamsModel.leftIndex = baseIndex
                indicatorParamsModel.leftItemFrame = leftItemFrame
                indicatorParamsModel.rightIndex = baseIndex + 1
                indicatorParamsModel.rightItemFrame = rightItemFrame
                indicatorParamsModel.percent = remainderProgress

                if remainderProgress == 0 {
                    //滑动翻页，需要更新选中状态
                    //滑动一小段距离，然后放开回到原位，contentOffset同样的值会回调多次。例如在index为1的情况，滑动放开回到原位，contentOffset会多次回调CGPoint(width, 0)
                    if !(lastContentOffset.x == contentOffset.x && selectedIndex == baseIndex) {
                        scrollSelectItemAt(index: baseIndex)
                    }
                }else {
                    //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
                    if abs(progress - CGFloat(selectedIndex)) > 1 {
                        var targetIndex = baseIndex
                        if progress < CGFloat(selectedIndex) {
                            targetIndex = baseIndex + 1
                        }
                        scrollSelectItemAt(index: targetIndex)
                    }
                    if selectedIndex == baseIndex {
                        scrollingTargetIndex = baseIndex + 1
                    }else {
                        scrollingTargetIndex = baseIndex
                    }

                    dataSource?.refreshItemModel(self, leftItemModel: itemDataSource[baseIndex], rightItemModel: itemDataSource[baseIndex + 1], percent: remainderProgress)

                    for indicator in indicators {
                        indicator.contentScrollViewDidScroll(model: indicatorParamsModel)
                        if indicator.isIndicatorConvertToItemFrameEnabled {
                            var leftIndicatorConvertToItemFrame = indicator.frame
                            leftIndicatorConvertToItemFrame.origin.x -= leftItemFrame.origin.x
                            itemDataSource[baseIndex].indicatorConvertToItemFrame = leftIndicatorConvertToItemFrame

                            var rightIndicatorConvertToItemFrame = indicator.frame
                            rightIndicatorConvertToItemFrame.origin.x -= rightItemFrame.origin.x
                            itemDataSource[baseIndex + 1].indicatorConvertToItemFrame = rightIndicatorConvertToItemFrame
                        }
                    }

                    let leftCell = collectionView.cellForItem(at: IndexPath(item: baseIndex, section: 0)) as? JXSegmentedBaseCell
                    leftCell?.reloadData(itemModel: itemDataSource[baseIndex], selectedType: .unknown)

                    let rightCell = collectionView.cellForItem(at: IndexPath(item: baseIndex + 1, section: 0)) as? JXSegmentedBaseCell
                    rightCell?.reloadData(itemModel: itemDataSource[baseIndex + 1], selectedType: .unknown)

                    listContainer?.scrolling(from: baseIndex, to: baseIndex + 1, percent: remainderProgress, selectedIndex: selectedIndex)
                    delegate?.segmentedView(self, scrollingFrom: baseIndex, to: baseIndex + 1, percent: remainderProgress)
                }
            }
            lastContentOffset = contentOffset
        }
    }

    //MARK: - Private
    private func clickSelectItemAt(index: Int) {
        guard delegate?.segmentedView(self, canClickItemAt: index) != false else {
            return
        }
        selectItemAt(index: index, selectedType: .click)
    }

    private func scrollSelectItemAt(index: Int) {
        selectItemAt(index: index, selectedType: .scroll)
    }

    private func selectItemAt(index: Int, selectedType: JXSegmentedViewItemSelectedType) {
        guard index >= 0 && index < itemDataSource.count else {
            return
        }

        if index == selectedIndex {
            if selectedType == .code {
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .click {
                delegate?.segmentedView(self, didClickSelectedItemAt: index)
                listContainer?.didClickSelectedItem(at: index)
            }else if selectedType == .scroll {
                delegate?.segmentedView(self, didScrollSelectedItemAt: index)
            }
            delegate?.segmentedView(self, didSelectedItemAt: index)
            scrollingTargetIndex = -1
            return
        }

        let currentSelectedItemModel = itemDataSource[selectedIndex]
        let willSelectedItemModel = itemDataSource[index]
        dataSource?.refreshItemModel(self, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        let currentSelectedCell = collectionView.cellForItem(at: IndexPath(item: selectedIndex, section: 0)) as? JXSegmentedBaseCell
        currentSelectedCell?.reloadData(itemModel: currentSelectedItemModel, selectedType: selectedType)

        let willSelectedCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? JXSegmentedBaseCell
        willSelectedCell?.reloadData(itemModel: willSelectedItemModel, selectedType: selectedType)

        if scrollingTargetIndex != -1 && scrollingTargetIndex != index {
            let scrollingTargetItemModel = itemDataSource[scrollingTargetIndex]
            scrollingTargetItemModel.isSelected = false
            dataSource?.refreshItemModel(self, currentSelectedItemModel: scrollingTargetItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)
            let scrollingTargetCell = collectionView.cellForItem(at: IndexPath(item: scrollingTargetIndex, section: 0)) as? JXSegmentedBaseCell
            scrollingTargetCell?.reloadData(itemModel: scrollingTargetItemModel, selectedType: selectedType)
        }

        if dataSource?.isItemWidthZoomEnabled == true {
            if selectedType == .click || selectedType == .code {
                //延时为了解决cellwidth变化，点击最后几个cell，scrollToItem会出现位置偏移bu。需要等cellWidth动画渐变结束后再滚动到index的cell位置。
                let selectedAnimationDurationInMilliseconds = Int((dataSource?.selectedAnimationDuration ?? 0)*1000)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(selectedAnimationDurationInMilliseconds)) {
                    self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
                }
            }else if selectedType == .scroll {
                //滚动选中的直接处理
                collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }else {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }

        if contentScrollView != nil && (selectedType == .click || selectedType == .code) {
            contentScrollView!.setContentOffset(CGPoint(x: contentScrollView!.bounds.size.width*CGFloat(index), y: 0), animated: isContentScrollViewClickTransitionAnimationEnabled)
        }

        let lastSelectedIndex = selectedIndex
        selectedIndex = index

        let currentSelectedItemFrame = getItemFrameAt(index: selectedIndex)
        for indicator in indicators {
            let indicatorParamsModel = JXSegmentedIndicatorParamsModel()
            indicatorParamsModel.lastSelectedIndex = lastSelectedIndex
            indicatorParamsModel.currentSelectedIndex = selectedIndex
            indicatorParamsModel.currentSelectedItemFrame = currentSelectedItemFrame
            indicatorParamsModel.selectedType = selectedType
            indicator.selectItem(model: indicatorParamsModel)

            if indicator.isIndicatorConvertToItemFrameEnabled {
                var indicatorConvertToItemFrame = indicator.frame
                indicatorConvertToItemFrame.origin.x -= currentSelectedItemFrame.origin.x
                itemDataSource[selectedIndex].indicatorConvertToItemFrame = indicatorConvertToItemFrame
                willSelectedCell?.reloadData(itemModel: willSelectedItemModel, selectedType: selectedType)
            }
        }

        scrollingTargetIndex = -1
        if selectedType == .code {
            listContainer?.didClickSelectedItem(at: index)
        }else if selectedType == .click {
            delegate?.segmentedView(self, didClickSelectedItemAt: index)
            listContainer?.didClickSelectedItem(at: index)
        }else if selectedType == .scroll {
            delegate?.segmentedView(self, didScrollSelectedItemAt: index)
        }
        delegate?.segmentedView(self, didSelectedItemAt: index)
    }

    private func getItemFrameAt(index: Int) -> CGRect {
        guard index < itemDataSource.count else {
            return CGRect.zero
        }
        var x = getContentEdgeInsetLeft()
        for i in 0..<index {
            let itemModel = itemDataSource[i]
            var itemWidth: CGFloat = 0
            if itemModel.isTransitionAnimating && itemModel.isItemWidthZoomEnabled {
                //正在进行动画的时候，itemWidthCurrentZoomScale是随着动画渐变的，而没有立即更新到目标值
                if itemModel.isSelected {
                    itemWidth = (dataSource?.segmentedView(self, widthForItemAt: itemModel.index, isItemWidthZoomValid: false) ?? 0) * itemModel.itemWidthSelectedZoomScale
                }else {
                    itemWidth = (dataSource?.segmentedView(self, widthForItemAt: itemModel.index, isItemWidthZoomValid: false) ?? 0) * itemModel.itemWidthNormalZoomScale
                }
            }else {
                itemWidth = itemModel.itemWidth
            }
            x += itemWidth + innerItemSpacing
        }
        var width: CGFloat = 0
        let selectedItemModel = itemDataSource[index]
        if selectedItemModel.isTransitionAnimating && selectedItemModel.isItemWidthZoomEnabled {
            width = (dataSource?.segmentedView(self, widthForItemAt: selectedItemModel.index, isItemWidthZoomValid: false) ?? 0) * selectedItemModel.itemWidthSelectedZoomScale
        }else {
            width = selectedItemModel.itemWidth
        }
        return CGRect(x: x, y: 0, width: width, height: bounds.size.height)
    }

    private func getContentEdgeInsetLeft() -> CGFloat {
        if contentEdgeInsetLeft == JXSegmentedViewAutomaticDimension {
            return innerItemSpacing
        }else {
            return contentEdgeInsetLeft
        }
    }

    private func getContentEdgeInsetRight() -> CGFloat {
        if contentEdgeInsetRight == JXSegmentedViewAutomaticDimension {
            return innerItemSpacing
        }else {
            return contentEdgeInsetRight
        }
    }
}

extension JXSegmentedView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = dataSource?.segmentedView(self, cellForItemAt: indexPath.item) {
            cell.reloadData(itemModel: itemDataSource[indexPath.item], selectedType: .unknown)
            return cell
        }else {
            return UICollectionViewCell(frame: CGRect.zero)
        }
    }
}

extension JXSegmentedView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var isTransitionAnimating = false
        for itemModel in itemDataSource {
            if itemModel.isTransitionAnimating {
                isTransitionAnimating = true
                break
            }
        }
        if !isTransitionAnimating {
            //当前没有正在过渡的item，才允许点击选中
            clickSelectItemAt(index: indexPath.item)
        }
    }
}

extension JXSegmentedView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: getContentEdgeInsetLeft(), bottom: 0, right: getContentEdgeInsetRight())
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemDataSource[indexPath.item].itemWidth, height: collectionView.bounds.size.height)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return innerItemSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return innerItemSpacing
    }
}
