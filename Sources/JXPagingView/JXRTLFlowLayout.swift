//
//  JXPagingView.swift
//  JXRTLFlowLayout
//
//  Created by jx on 2024/5/27.
//

import UIKit

class JXRTLFlowLayout: UICollectionViewFlowLayout {
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        get {
            return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
        }
    }
}
