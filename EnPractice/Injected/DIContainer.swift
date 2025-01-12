//
//  DIContainer.swift
//  EnPractice
//
//  Created by 정영민 on 7/20/24.
//

import SwiftUI
import Combine

// MARK: - DIContainer

struct DIContainer: EnvironmentKey {
    let appState: Store<AppState>
    let useCases: UseCases
    
    init(appState: Store<AppState>, useCases: DIContainer.UseCases) {
        self.appState = appState
        self.useCases = useCases
    }
    
    init(appState: AppState, useCases: DIContainer.UseCases) {
        self.init(appState: Store(appState), useCases: useCases)
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = DIContainer.preview
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        let appState = Store<AppState>(AppState())
        
        let loginWebRepository = LoginWebRepositoryStub()
        let dbRepositories = DIContainer.DBRepositories(lessonDBRepository: StubLessonDBRepository())
        let loginUseCase = RealLoginUseCase(webRepository: loginWebRepository)
        let lessonUseCase = LessonUseCaseImp()
        let userPermissionsUseCase = RealUserPermissionsUseCase(
            appState: appState, openAppSettings: {
                URL(string: UIApplication.openSettingsURLString).flatMap {
                    UIApplication.shared.open($0, options: [:], completionHandler: nil)
                }
            })
        
        let useCases = DIContainer.UseCases(
            loginUseCase: loginUseCase,
            userPermissionsUseCase: userPermissionsUseCase,
            lessonUseCase: lessonUseCase)
        
        return DIContainer(appState: appState, useCases: useCases)
    }
}
#endif

