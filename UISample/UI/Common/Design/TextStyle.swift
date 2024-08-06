//
//  TextStyle.swift
//  UISample
//
//  Created by 정영민 on 8/6/24.
//

import SwiftUI

enum TextStyle {
    case h1
    
    case h2
    
    case subtitle1
    
    case subtitle2
    
    case subtitle3
    
    case body1
    
    case body2
    
    case caption1
    
    case caption2
    
    var font: Font {
        switch self {
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
        }
    }
    
    var lineSpacing: CGFloat {
        return 4
    }
    
    func attributes(alignment: NSTextAlignment = .left, color: UIColor? = nil, lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> [NSAttributedString.Key : Any] {
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        style.lineBreakMode = lineBreakMode
        
        attributes[.paragraphStyle] = style
        attributes[.font] = font
        if let color = color {
            attributes[.foregroundColor] = color
        }
        return attributes
    }
    
    func attributedString(string: String, color: UIColor? = nil, alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> NSMutableAttributedString {
        
        return NSMutableAttributedString(string: string, attributes: attributes(alignment: alignment, color: color, lineBreakMode: lineBreakMode))
    }
}
