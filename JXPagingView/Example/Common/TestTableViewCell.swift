//
//  TestTableViewCell.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/9/10.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    var bgButtonClicked: (()->())?
    private var bgButton: UIButton?

    deinit {
        bgButtonClicked = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initializeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initializeViews()
    }

    func initializeViews() {
        bgButton = UIButton(type: .custom)
        contentView.addSubview(bgButton!)
        bgButton?.addTarget(self, action: #selector(bgButtonClicked(btn:)), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bgButton?.frame = contentView.bounds
    }

    @objc func bgButtonClicked(btn: UIButton) {
        bgButtonClicked?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
