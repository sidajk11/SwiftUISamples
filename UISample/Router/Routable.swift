//
//  Routable.swift
//  UISample
//
//  Created by 정영민 on 2024/06/12.
//

import Foundation

public protocol Routable: Hashable, Identifiable {
    
}

extension Routable {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
