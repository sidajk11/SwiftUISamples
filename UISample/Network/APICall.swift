//
//  APICall.swift
//  UISample
//
//  Created by 정영민 on 2024/06/13.
//

import Foundation

protocol APICall {
    var serverUrl: String { get }
    
    var path: String { get }
    
    var method: String { get }
    
    var headers: [String: String] { get }
    
    // Data
    var query: [String : Any] { get }
    
    var bodyObject: Codable? { get }
    
    var bodyDict: [String : Any] { get }
    
    var formData: [FormData] { get }
}

extension APICall {
    var serverUrl: String { return "" }
    
    var path: String { return "" }
    
    var method: String { return "" }
    
    var headers: [String: String] { return [:] }
    
    // Data
    var query: [String : Any] { return [:] }
    
    var bodyObject: Codable? { return nil }
    
    var bodyDict: [String : Any] { return [:] }
    
    var formData: [FormData] { return [] }
}

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageDeserialization: return "Cannot deserialize image from Data"
        }
    }
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        if let body = self.bodyObject, let bodyData = try? JSONEncoder().encode(body) {
            request.httpBody = bodyData
        }
        else if formData.count > 0 {
            let formCreator = MultipartFormCreator(formDataArray: formData)
            request.httpBody = formCreator.createBody()
            let (key, value) = formCreator.formDataHeader()
            request.addValue(key, forHTTPHeaderField: value)
        }
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
