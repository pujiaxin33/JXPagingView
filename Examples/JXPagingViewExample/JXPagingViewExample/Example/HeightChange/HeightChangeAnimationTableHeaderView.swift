//
//  HeightChangeAnimationtitleLabel.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/7/8.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class HeightChangeAnimationTableHeaderView: PagingViewTableHeaderView {
    var toggleCallback: ((Bool) -> ())?
    private let titleLabel: UILabel
    private let toggleButton: UIButton
    private let descLabel: UILabel

    deinit {
        toggleCallback = nil
    }

    override init(frame: CGRect) {
        titleLabel = UILabel()
        descLabel = UILabel()
        toggleButton = UIButton(type: .custom)
        super.init(frame: frame)

        subviews.forEach { $0.removeFromSuperview() }

        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.text = "这是简介标题"
        titleLabel.frame = CGRect(x: 20, y: 20, width: 150, height: 20)
        addSubview(titleLabel)

        toggleButton.setTitleColor(.black, for: .normal)
        toggleButton.setTitle("展开", for: .normal)
        toggleButton.setTitle("收拢", for: .selected)
        toggleButton.addTarget(self, action: #selector(toggleButtonDidClicked(_:)), for: .touchUpInside)
        toggleButton.frame = CGRect(x: titleLabel.frame.maxX + 30, y: titleLabel.frame.minY, width: 80, height: 20)
        toggleButton.layer.borderColor = UIColor.red.cgColor
        toggleButton.layer.borderWidth = 1
        toggleButton.layer.cornerRadius = 10
        addSubview(toggleButton)

        descLabel.text = "这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。这是一个descLabel，仅用于表示上面有内容。"
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 0
        descLabel.frame = CGRect(x: 20, y: titleLabel.frame.maxY + 10, width: UIScreen.main.bounds.self.width - 40, height: 20)
        addSubview(descLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func toggleButtonDidClicked(_ btn: UIButton) {
        btn.isSelected.toggle()
        toggleCallback?(btn.isSelected)
        resizeWithAnimation(btn.isSelected)
    }

    func resizeWithAnimation(_ expand: Bool) {
        //TableHeaderView内部元素的动画，自己根据业务要求实现。
        if expand {
            var frame = descLabel.frame
            frame.size.height = 190
            UIView.animate(withDuration: 0.25) {
                self.descLabel.frame = frame
            }
        }else {
            var frame = descLabel.frame
            frame.size.height = 20
            UIView.animate(withDuration: 0.25) {
                self.descLabel.frame = frame
            }
        }
    }
}
