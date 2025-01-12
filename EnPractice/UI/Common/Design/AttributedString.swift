//
//  AttributedString.swift
//  EnPractice
//
//  Created by 정영민 on 8/6/24.
//

import SwiftUI

extension AttributedString {
    static func h1(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.h1, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func h2(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.h2, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func subtitle1(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.subtitle1, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func subtitle2(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.subtitle2, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func subtitle3(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.subtitle3, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func body1(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.body1, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func body2(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.body2, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func caption1(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.caption1, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func caption2(string: String, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        return attributedString(string: string, font: Font.caption2, lineSpacing: 4, color: color, alignment: alignment)
    }
    
    static func attributedString(string: String, font: Font, lineSpacing: CGFloat, color: Color? = nil, alignment: NSTextAlignment = .left) -> AttributedString {
        var attributeString = AttributedString(stringLiteral: string)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        style.lineBreakMode = .byWordWrapping
        
        let count = (string as NSString).length
        
        attributeString.font = font
        attributeString.mergeAttributes(.init([.paragraphStyle : style]))
        if let color = color {
            attributeString.foregroundColor = color
        }
        
        return attributeString
    }
}

extension AttributedString {
    @discardableResult
    mutating func setColor(color: Color, text: String) -> Self {
        
        if let range = self.range(of: text) {
            self[range].foregroundColor = color
        }
        return self
    }
    
    @discardableResult
    mutating func setAlignment(alignment: NSTextAlignment, lineSpacing: CGFloat = 4) -> Self {
        
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineSpacing = lineSpacing
        
        self.mergeAttributes(.init([.paragraphStyle : style]))
        return self
    }
}
