//
//  UIFont.swift
//  UISample
//
//  Created by 정영민 on 8/7/24.
//

import UIKit
import SwiftUI

extension UIFont {
    static func from(_ font: Font) -> UIFont {
        switch font {
        case .h1:
            return .h1
        case .h2:
            return .h2
        case .subtitle1:
            return .subtitle1
        case .subtitle2:
            return .subtitle2
        case .subtitle3:
            return .subtitle3
        case .body1:
            return .body1
        case .body2:
            return .body2
        case .caption1:
            return .caption1
        case .caption2:
            return .caption2
        default:
            return .h1
        }
    }
    
    static var h1: UIFont {
        return font(size: 24, weight: .bold)
    }
    
    static var h2: UIFont {
        return font(size: 18, weight: .bold)
    }
    
    static var subtitle1: UIFont {
        return font(size: 16, weight: .bold)
    }
    
    static var subtitle2: UIFont {
        return font(size: 14, weight: .bold)
    }
    
    static var subtitle3: UIFont {
        return font(size: 12, weight: .bold)
    }
    
    static var body1: UIFont {
        return font(size: 16, weight: .regular)
    }
    
    static var body2: UIFont {
        return font(size: 14, weight: .regular)
    }
    
    static var caption1: UIFont {
        return font(size: 12, weight: .regular)
    }
    
    static var caption2: UIFont {
        return font(size: 10, weight: .bold)
    }
    
    static func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}
