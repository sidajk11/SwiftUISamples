//
//  LoginRepository.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import Foundation
import Combine

protocol LoginWebRepository: WebRepository {
    func signUp()
    
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error>
    
    func logout()
}

class RealLoginWebRepository: LoginWebRepository {
    var session: URLSession = URLSession.shared
    var baseURL: String = "http://127.0.0.1:8000/"
    var bgQueue: DispatchQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func signUp() {
        
    }
    
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error> {
        return call(endpoint: API.login(username, password))
    }
    
    func logout() {
        
    }
}

extension RealLoginWebRepository {
    enum API {
        case signUp
        case login(_ username: String, _ password: String)
        case logout
    }
}

extension RealLoginWebRepository.API: APICall {
    var path: String {
        switch self {
        case .signUp:
            return ""
        case .login:
            return "/api/v1/token"
        case .logout:
            return ""
        }
    }
}
