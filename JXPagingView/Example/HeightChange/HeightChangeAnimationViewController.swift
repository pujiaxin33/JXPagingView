//
//  HeightChangeAnimationViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2019/7/8.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class HeightChangeAnimationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        JXTableHeaderViewHeight = 350
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "高度", style: .plain, target: self, action: #selector(didNaviRightItemClicked))
    }

    override func preferredTableHeaderView() -> PagingViewTableHeaderView {
        return HeightChangeAnimationTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 350))
    }

    @objc func didNaviRightItemClicked() {
        //改变JXTableHeaderViewHeight的值
        if JXTableHeaderViewHeight == 350 {
            JXTableHeaderViewHeight = 200

            (userHeaderView as? HeightChangeAnimationTableHeaderView)?.resizeWithAnimation(false)
            pagingView.resizeTableHeaderViewHeight(200, animatable: true)
        }else {
            JXTableHeaderViewHeight = 350

            (userHeaderView as? HeightChangeAnimationTableHeaderView)?.resizeWithAnimation(true)
            pagingView.resizeTableHeaderViewHeight(350, animatable: true)
        }
    }

}
