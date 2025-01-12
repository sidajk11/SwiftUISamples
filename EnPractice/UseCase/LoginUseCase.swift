//
//  LoginUseCase.swift
//  EnPractice
//
//  Created by 정영민 on 7/15/24.
//

import Foundation
import Combine

protocol LoginUseCase {
    func signUp()
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error>
    func logout()
}

class RealLoginUseCase: LoginUseCase {
    let webRepository: LoginWebRepository
    
    init(webRepository: LoginWebRepository) {
        self.webRepository = webRepository
    }
    
    func signUp() {
        
    }
    
    func login(username: String, password: String) -> AnyPublisher<TokenModel, Error> {
        return webRepository.login(username: username, password: password)
    }
    
    func logout() {
        
    }
}
