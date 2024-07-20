//
//  ServicesContainer.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import Foundation

extension DIContainer {
    struct Services {
        let loginService: LoginService
        let userPermissionsService: UserPermissionsService
        
        init(loginService: LoginService,
             userPermissionsService: UserPermissionsService) {
            self.loginService = loginService
            self.userPermissionsService = userPermissionsService
        }
        
        static var stub: Self {
            .init(loginService: StubLoginService(),
                  userPermissionsService: StubUserPermissionsService())
        }
    }
}
