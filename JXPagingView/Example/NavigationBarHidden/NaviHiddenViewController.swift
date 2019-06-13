//
//  NaviHiddenViewController.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class NaviHiddenViewController: BaseViewController {
    var naviBGView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.automaticallyAdjustsScrollViewInsets = false

        let topSafeMargin = UIApplication.shared.keyWindow!.jx_layoutInsets().top
        let naviHeight = UIApplication.shared.keyWindow!.jx_navigationHeight()
        //导航栏隐藏就是设置pinSectionHeaderVerticalOffset属性即可，数值越大越往下沉
        pagingView.pinSectionHeaderVerticalOffset = Int(naviHeight)

        //自定义导航栏
        naviBGView = UIView()
        naviBGView?.alpha = 0
        naviBGView?.backgroundColor = UIColor.white
        naviBGView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight)
        self.view.addSubview(naviBGView!)

        let naviTitleLabel = UILabel()
        naviTitleLabel.text = "导航栏隐藏"
        naviTitleLabel.textAlignment = .center
        naviTitleLabel.frame = CGRect(x: 0, y: topSafeMargin, width: self.view.bounds.size.width, height: 44)
        naviBGView?.addSubview(naviTitleLabel)

        let back = UIButton(type: .system)
        back.setTitle("返回", for: .normal)
        back.frame = CGRect(x: 12, y: topSafeMargin, width: 44, height: 44)
        back.addTarget(self, action: #selector(naviBack), for: .touchUpInside)
        naviBGView?.addSubview(back)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc func naviBack(){
        self.navigationController?.popViewController(animated: true)
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        let thresholdDistance: CGFloat = 100
        var percent = scrollView.contentOffset.y/thresholdDistance
        percent = max(0, min(1, percent))
        naviBGView?.alpha = percent
    }

}
