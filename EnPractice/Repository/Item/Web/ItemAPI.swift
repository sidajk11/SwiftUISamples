//
//  ItemAPI.swift
//  EnPractice
//
//  Created by 정영민 on 6/30/24.
//

import Foundation

extension RealItemWebRepository {
    enum API {
        case allItems
    }
}

extension RealItemWebRepository.API: APICall {
    var serverUrl: String { return "" }
    
    var path: String {
        switch self {
        case .allItems:
            return "/api/v1/items"
        }
    }
    
    var method: String {
        switch self {
        case .allItems:
            return "GET"
        }
    }
    
    var headers: [String: String] {
        return ["Accept": "application/json"]
    }
}
