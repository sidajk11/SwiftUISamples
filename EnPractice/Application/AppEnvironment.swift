//
//  AppEnvironment.swift
//  EnPractice
//
//  Created by 정영민 on 7/15/24.
//

import UIKit
import Combine

struct AppEnvironment {
    let container: DIContainer
    let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let dbRepositories = configuredDBRepositories(appState: appState)
        let useCases = useCases(
            appState: appState,
            dbRepositories: dbRepositories,
            webRepositories: webRepositories
        )
        let diContainer = DIContainer(appState: appState, useCases: useCases)
        let deepLinksHandler = RealDeepLinksHandler(container: diContainer)
        let pushNotificationsHandler = RealPushNotificationsHandler(deepLinksHandler: deepLinksHandler)
        let systemEventsHandler = RealSystemEventsHandler(
            container: diContainer, deepLinksHandler: deepLinksHandler,
            pushNotificationsHandler: pushNotificationsHandler)
        return AppEnvironment(container: diContainer,
                              systemEventsHandler: systemEventsHandler)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let loginWebRepository = RealLoginWebRepository(
            session: session,
            baseURL: "http://127.0.0.1:8000")
        return .init(loginWebRepository: loginWebRepository)
    }
    
    private static func configuredDBRepositories(appState: Store<AppState>) -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        let lessonDBRepository = RealLessonDBRepository(persistentStore: persistentStore)
        return .init(lessonDBRepository: lessonDBRepository)
    }
    
    private static func useCases(appState: Store<AppState>,
                                           dbRepositories: DIContainer.DBRepositories,
                                           webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.UseCases {
        
        
        let loginUseCase = RealLoginUseCase(
            webRepository: webRepositories.loginWebRepository)
        
        let userPermissionsUseCase = RealUserPermissionsUseCase(
            appState: appState, openAppSettings: {
                URL(string: UIApplication.openSettingsURLString).flatMap {
                    UIApplication.shared.open($0, options: [:], completionHandler: nil)
                }
            })
        
        let lessonUseCase = LessonUseCaseImp()
        
        return .init(loginUseCase: loginUseCase,
                     userPermissionsUseCase: userPermissionsUseCase,
                     lessonUseCase: lessonUseCase)
    }
}

extension DIContainer {
    struct WebRepositories {
        let loginWebRepository: LoginWebRepository
    }
    
    struct DBRepositories {
        let lessonDBRepository: LessonDBRepository
    }
}

