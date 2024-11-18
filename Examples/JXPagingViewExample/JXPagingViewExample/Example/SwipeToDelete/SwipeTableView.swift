//
//  SwipeTableView.swift
//  JXPagingViewExample
//
//  Created by Ja on 2024/11/18.
//  Copyright © 2024 jiaxin. All rights reserved.
//

import UIKit

class SwipeTableView: UITableView {
    weak var parentController: UIViewController?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard let parent = parentController?.parent else {
            return super.hitTest(point, with: event)
        }
        
        var swipe: SwipeDeleteController? = parent as? SwipeDeleteController
        
        if swipe == nil {
            swipe = parent.parent as? SwipeDeleteController
        }
        
        guard let swipe = swipe else {
            return super.hitTest(point, with: event)
        }
        
        var currentView: UIView? = super.hitTest(point, with: event)
        
        swipe.pagingView.isListHorizontalScrollEnabled = true
        while let cView = currentView {
            if cView is SwipeCell || cView is SwipeActionCell {
                swipe.pagingView.isListHorizontalScrollEnabled = false
                
//                return cView // 打开注释后再看SwipeActionListViewController中点击按钮的效果
                return cView is SwipeCell ? cView : super.hitTest(point, with: event)
            }
            currentView = cView.superview
        }
        
        return super.hitTest(point, with: event)
    }
}

class SwipeCell: UITableViewCell {}


protocol SwipeActionCellDelegate: NSObjectProtocol {
    func swipeCellAction(in cell: SwipeActionCell)
}

class SwipeActionCell: UITableViewCell {
    
    weak var delegate: SwipeActionCellDelegate?
    
    lazy var actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("点击", for: .normal)
        btn.addTarget(self, action: #selector(cellAction), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        contentView.addSubview(actionButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        actionButton.frame = CGRect(x: contentView.frame.maxX - 60, y: 0, width: 40, height: contentView.bounds.size.height)
    }
    
    @objc
    func cellAction() {
        delegate?.swipeCellAction(in: self)
    }
}
