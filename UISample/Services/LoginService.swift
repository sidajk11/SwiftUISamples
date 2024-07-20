//
//  LoginService.swift
//  UISample
//
//  Created by 정영민 on 7/15/24.
//

import Foundation
import Combine

protocol LoginService {
    func signUp()
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error>
    func logout()
}

class RealLoginService: LoginService {
    let webRepository: LoginWebRepository
    let appState: Store<AppState>
    
    init(webRepository: LoginWebRepository, appState: Store<AppState>) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func signUp() {
        
    }
    
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error> {
        return webRepository.login(username: username, password: password)
    }
    
    func logout() {
        
    }
}

class StubLoginService: LoginService {
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
