//
//  JXSegmentedViewTool.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    var jx_red: CGFloat {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    var jx_green: CGFloat {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    var jx_blue: CGFloat {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    var jx_alpha: CGFloat {
        return cgColor.alpha
    }
}

public class JXSegmentedViewTool {
    public static func interpolate<T: SignedNumeric & Comparable>(from: T, to:  T, percent:  T) ->  T {
        let percent = max(0, min(1, percent))
        return from + (to - from) * percent
    }

    public static func interpolateColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        let r = interpolate(from: from.jx_red, to: to.jx_red, percent: percent)
        let g = interpolate(from: from.jx_green, to: to.jx_green, percent: CGFloat(percent))
        let b = interpolate(from: from.jx_blue, to: to.jx_blue, percent: CGFloat(percent))
        let a = interpolate(from: from.jx_alpha, to: to.jx_alpha, percent: CGFloat(percent))
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    public static func interpolateColors(from: [CGColor], to: [CGColor], percent: CGFloat) -> [CGColor] {
        var resultColors = [CGColor]()
        for index in 0..<from.count {
            let fromColor = UIColor(cgColor: from[index])
            let toColor = UIColor(cgColor: to[index])
            let r = interpolate(from: fromColor.jx_red, to: toColor.jx_red, percent: percent)
            let g = interpolate(from: fromColor.jx_green, to: toColor.jx_green, percent: CGFloat(percent))
            let b = interpolate(from: fromColor.jx_blue, to: toColor.jx_blue, percent: CGFloat(percent))
            let a = interpolate(from: fromColor.jx_alpha, to: toColor.jx_alpha, percent: CGFloat(percent))
            resultColors.append(UIColor(red: r, green: g, blue: b, alpha: a).cgColor)
        }
        return resultColors
    }
}
