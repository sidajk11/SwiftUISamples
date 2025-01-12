//
//  Routable.swift
//  EnPractice
//
//  Created by 정영민 on 2024/06/12.
//

import Foundation

public protocol Routable: Identifiable, Hashable {
    
}

extension Routable {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
