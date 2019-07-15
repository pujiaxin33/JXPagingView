//
//  HeightChangeAnimationTableHeaderView.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/7/8.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class HeightChangeAnimationTableHeaderView: PagingViewTableHeaderView {
    let topLabel: UILabel
    let bottomLabel: UILabel
    let toggleButton: UIButton

    override init(frame: CGRect) {
        topLabel = UILabel()
        bottomLabel = UILabel()
        toggleButton = UIButton(type: .custom)
        super.init(frame: frame)

        let screenSize = UIScreen.main.bounds.size
        subviews.forEach { $0.removeFromSuperview() }
        topLabel.text = "这是一个topLabel，仅用于表示上面有内容。这是一个topLabel，仅用于表示上面有内容。这是一个topLabel，仅用于表示上面有内容。"
        topLabel.textAlignment = .left
        topLabel.numberOfLines = 0
        topLabel.frame = CGRect(x: 10, y: 10, width: screenSize.width - 20, height: 100)
        addSubview(topLabel)

        bottomLabel.text = "这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。这是一个BottomLabel，仅用于表示上面有内容。"
        bottomLabel.textAlignment = .left
        bottomLabel.numberOfLines = 0
        bottomLabel.frame = CGRect(x: 10, y: topLabel.frame.maxY + 10, width: screenSize.width - 20, height: 180)
        addSubview(bottomLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resizeWithAnimation(_ expand: Bool) {
        if expand {
            var frame = bottomLabel.frame
            frame.size.height = 180
            UIView.animate(withDuration: 0.25) {
                self.bottomLabel.frame = frame
            }
        }else {
            var frame = bottomLabel.frame
            frame.size.height = 25
            UIView.animate(withDuration: 0.25) {
                self.bottomLabel.frame = frame
            }
        }
    }
}
