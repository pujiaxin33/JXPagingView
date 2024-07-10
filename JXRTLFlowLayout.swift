//
//  JXRTLFlowLayout.swift
//  JXPagingView
//
//  Created by Jiaxin Pu on 2024/7/10.
//

import UIKit

class JXRTLFlowLayout: UICollectionViewFlowLayout {
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        get {
            return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
        }
    }
}
