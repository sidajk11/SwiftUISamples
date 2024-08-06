//
//  Font.swift
//  UISample
//
//  Created by 정영민 on 8/6/24.
//

import SwiftUI

extension Font {
    static var h1: Font {
        return font(size: 24, weight: .bold)
    }
    
    static var h2: Font {
        return font(size: 18, weight: .bold)
    }
    
    static var subtitle1: Font {
        return font(size: 16, weight: .bold)
    }
    
    static var subtitle2: Font {
        return font(size: 14, weight: .bold)
    }
    
    static var subtitle3: Font {
        return font(size: 12, weight: .bold)
    }
    
    static var body1: Font {
        return font(size: 16, weight: .regular)
    }
    
    static var body2: Font {
        return font(size: 14, weight: .regular)
    }
    
    static var caption1: Font {
        return font(size: 12, weight: .regular)
    }
    
    static var caption2: Font {
        return font(size: 10, weight: .bold)
    }
    
    static func font(size: CGFloat, weight: Font.Weight) -> Font {
        return Font.system(size: size, weight: weight)
    }
}
