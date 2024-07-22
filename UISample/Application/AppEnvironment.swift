//
//  AppEnvironment.swift
//  UISample
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
        /*
         To see the deep linking in action:
         
         1. Launch the app in iOS 13.4 simulator (or newer)
         2. Subscribe on Push Notifications with "Allow Push" button
         3. Minimize the app
         4. Drag & drop "push_with_deeplink.apns" into the Simulator window
         5. Tap on the push notification
         
         Alternatively, just copy the code below before the "return" and launch:
         
            DispatchQueue.main.async {
                deepLinksHandler.open(deepLink: .showCountryFlag(alpha3Code: "AFG"))
            }
        */
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let dbRepositories = configuredDBRepositories(appState: appState)
        let services = configuredServices(appState: appState,
                                                dbRepositories: dbRepositories,
                                                webRepositories: webRepositories)
        let diContainer = DIContainer(appState: appState, services: services)
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
    
    private static func configuredServices(appState: Store<AppState>,
                                           dbRepositories: DIContainer.DBRepositories,
                                           webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Services {
        
        let loginService = RealLoginService(
            webRepository: webRepositories.loginWebRepository,
            appState: appState)
        
        let userPermissionsService = RealUserPermissionsService(
            appState: appState, openAppSettings: {
                URL(string: UIApplication.openSettingsURLString).flatMap {
                    UIApplication.shared.open($0, options: [:], completionHandler: nil)
                }
            })
        
        return .init(loginService: loginService,
                     userPermissionsService: userPermissionsService)
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

