//
//  String+Size.swift
//  ReelChat
//
//  Created by 정영민 on 2024/03/04.
//

import SwiftUI

extension String {
    func height(withConstrainedWidth width: CGFloat, font: Font) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }
    
    func height(withConstrainedWidth width: CGFloat, attributes: [NSAttributedString.Key : Any]) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    
        return ceil(boundingBox.height)
    }
    
    func rect(withConstrainedWidth width: CGFloat, attributes: [NSAttributedString.Key : Any]) -> CGRect {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    
        return boundingBox
    }
    
    func rect(withConstrainedWidth width: CGFloat, textStyle: TextStyle, alignment: NSTextAlignment = .left) -> CGRect {
        var attributes: [NSAttributedString.Key : Any] = [:]
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = textStyle.lineSpacing
        style.alignment = alignment
        // byTruncatingTail 으로 하면 버그가 있음
        style.lineBreakMode = .byWordWrapping
        
        attributes[.paragraphStyle] = style
        attributes[.font] = textStyle.font
        
        return rect(withConstrainedWidth: width, attributes: attributes)
    }

    func width(withConstrainedHeight height: CGFloat, font: Font) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.from(font)], context: nil)

        return ceil(boundingBox.width)
    }
    
    func lineNumber(withConstrainedWidth width: CGFloat, textStyle: TextStyle) -> Int {
        let textStorage = NSTextStorage(string: self)
        let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(.font, value: textStyle.font, range: NSRange(location: 0, length: textStorage.length))

        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byWordWrapping

        layoutManager.glyphRange(for: textContainer)

        let numberOfLines = layoutManager.numberOfLines
        return numberOfLines
    }
}

extension NSLayoutManager {
    var numberOfLines: Int {
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange(location: NSNotFound, length: 0)

        while index < numberOfGlyphs {
            lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            numberOfLines += 1
            index = NSMaxRange(lineRange)
        }

        return numberOfLines
    }
}
