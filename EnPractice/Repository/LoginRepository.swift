//
//  LoginRepository.swift
//  EnPractice
//
//  Created by 정영민 on 7/20/24.
//

import Foundation
import Combine

protocol LoginWebRepository {
    func signUp()
    
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error>
    
    func logout()
}

class RealLoginWebRepository: LoginWebRepository, WebRepository {
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
    
    var bodyDict: [String : Any] {
        switch self {
        case .signUp:
            return [:]
        case .login(let username, let password):
            return ["username" : username, "password" : password]
        default:
            return [:]
        }
    }
}


class LoginWebRepositoryStub: LoginWebRepository {
    func signUp() {
        
    }
    
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error> {
        let model = TokenModel(access_token: "", token_type: "")
        return Just(model)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func logout() {
        
    }
}
