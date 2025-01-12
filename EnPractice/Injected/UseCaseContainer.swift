//
//  ServicesContainer.swift
//  EnPractice
//
//  Created by 정영민 on 7/20/24.
//

import Foundation

extension DIContainer {
    struct UseCases {
        let loginUseCase: LoginUseCase
        let userPermissionsUseCase: UserPermissionsUseCase
        let lessonUseCase: LessonUseCase
        
        init(loginUseCase: LoginUseCase,
             userPermissionsUseCase: UserPermissionsUseCase,
             lessonUseCase: LessonUseCase) {
            self.loginUseCase = loginUseCase
            self.userPermissionsUseCase = userPermissionsUseCase
            self.lessonUseCase = lessonUseCase
        }
    }
}
