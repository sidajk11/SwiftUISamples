//
//  SystemEventsHandler.swift
//  EnPractice
//
//  Created by 정영민 on 2024/06/13.
//

import UIKit
import Combine

typealias NotificationPayload = [AnyHashable: Any]
typealias FetchCompletion = (UIBackgroundFetchResult) -> Void

protocol SystemEventsHandler {
    func sceneOpenURLContexts(_ urlContexts: Set<UIOpenURLContext>)
    func sceneDidBecomeActive()
    func sceneWillResignActive()
    
    func handle(url: URL)
    func handlePushRegistration(result: Result<Data, Error>)
    func appDidReceiveRemoteNotification(payload: NotificationPayload,
                                         fetchCompletion: @escaping FetchCompletion)
}

struct RealSystemEventsHandler: SystemEventsHandler {
    
    let container: DIContainer
    let deepLinksHandler: DeepLinksHandler
    let pushNotificationsHandler: PushNotificationsHandler
    private var cancelBag = CancelBag()
    
    init(container: DIContainer,
         deepLinksHandler: DeepLinksHandler,
         pushNotificationsHandler: PushNotificationsHandler) {
        
        self.container = container
        self.deepLinksHandler = deepLinksHandler
        self.pushNotificationsHandler = pushNotificationsHandler
        
        installKeyboardHeightObserver()
        installPushNotificationsSubscriberOnLaunch()
    }
     
    private func installKeyboardHeightObserver() {
        let appState = container.appState
        NotificationCenter.default.keyboardHeightPublisher
            .sink { [appState] height in
                appState[\.system.keyboardHeight] = height
            }
            .store(in: cancelBag)
    }
     
    private func installPushNotificationsSubscriberOnLaunch() {
        weak var permissions = container.useCases.userPermissionsUseCase
        container.appState
            .updates(for: AppState.permissionKeyPath(for: .pushNotifications))
            .first(where: { $0 != .unknown })
            .sink { status in
                if status == .granted {
                    // If the permission was granted on previous launch
                    // requesting the push token again:
                    permissions?.request(permission: .pushNotifications)
                }
            }
            .store(in: cancelBag)
    }
    
    func sceneOpenURLContexts(_ urlContexts: Set<UIOpenURLContext>) {
        guard let url = urlContexts.first?.url else { return }
        handle(url: url)
    }
    
    func handle(url: URL) {
        guard let deepLink = DeepLink(url: url) else { return }
        deepLinksHandler.open(deepLink: deepLink)
    }
    
    func sceneDidBecomeActive() {
        container.appState[\.system.isActive] = true
        container.useCases.userPermissionsUseCase.resolveStatus(for: .pushNotifications)
    }
    
    func sceneWillResignActive() {
        container.appState[\.system.isActive] = false
    }
    
    func handlePushRegistration(result: Result<Data, Error>) {

    }
    
    func appDidReceiveRemoteNotification(payload: NotificationPayload,
                                         fetchCompletion: @escaping FetchCompletion) {
    }
}

// MARK: - Notifications

private extension NotificationCenter {
    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        let willShow = publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return Publishers.Merge(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

private extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
            .cgRectValue.height ?? 0
    }
}
