//
//  Request.swift
//  EnPractice
//
//  Created by 정영민 on 6/30/24.
//

import Foundation

class Request: APICall {
    var serverUrl: String { return "" }
    
    var path: String { return "" }
    
    var method: String { return "" }
    
    var headers: [String: String] {
        return ["Accept": "application/json"]
    }
    
    // Data
    var query: [String : Any] { return [:] }
    
    var bodyObject: Codable? { return nil }
    
    var bodyDict: [String : Any] { return [:] }
    
    var formData: [FormData] { return [] }
}
