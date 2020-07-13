//
//  PagingViewTableHeaderView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class PagingViewTableHeaderView: UIView {
    lazy var imageView: UIImageView = UIImageView(image: UIImage(named: "lufei.jpg"))
    var imageViewFrame: CGRect = CGRect.zero

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(imageView)

        let label = UILabel(frame: CGRect(x: 10, y: frame.size.height - 30, width: 200, height: 30))
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Monkey·D·路飞"
        label.textColor = UIColor.red
        label.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
        self.addSubview(label)

        let follow = UIButton(type: .system)
        follow.setTitle("关注", for: .normal)
        follow.addTarget(self, action: #selector(followDidClick), for: .touchUpInside)
        follow.frame = CGRect(x: label.frame.maxX + 10, y: label.frame.minY, width: 50, height: 30)
        addSubview(follow)
        follow.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            follow.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5).isActive = true
            follow.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageViewFrame = bounds
    }

    func scrollViewDidScroll(contentOffsetY: CGFloat) {
        var frame = imageViewFrame
        frame.size.height -= contentOffsetY
        frame.origin.y = contentOffsetY
        imageView.frame = frame
    }

    @objc func followDidClick() {
        print("关注成功")
    }

}
