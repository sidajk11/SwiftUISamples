//
//  UserPermissionsUseCase.swift
//  EnPractice
//
//  Created by 정영민 on 2024/06/13.
//

import Foundation
import UserNotifications

enum Permission {
    case pushNotifications
}

extension Permission {
    enum Status: Equatable {
        case unknown
        case notRequested
        case granted
        case denied
    }
}

protocol UserPermissionsUseCase: AnyObject {
    func resolveStatus(for permission: Permission)
    func request(permission: Permission)
}

// MARK: - RealUserPermissionsUseCase

final class RealUserPermissionsUseCase: UserPermissionsUseCase {
    
    private let appState: Store<AppState>
    private let openAppSettings: () -> Void
    
    init(appState: Store<AppState>, openAppSettings: @escaping () -> Void) {
        self.appState = appState
        self.openAppSettings = openAppSettings
    }
    
    func resolveStatus(for permission: Permission) {
        let keyPath = AppState.permissionKeyPath(for: permission)
        let currentStatus = appState[keyPath]
        guard currentStatus == .unknown else { return }
        let onResolve: (Permission.Status) -> Void = { [weak appState] status in
            appState?[keyPath] = status
        }
        switch permission {
        case .pushNotifications:
            pushNotificationsPermissionStatus(onResolve)
        }
    }
    
    func request(permission: Permission) {
        let keyPath = AppState.permissionKeyPath(for: permission)
        let currentStatus = appState[keyPath]
        guard currentStatus != .denied else {
            openAppSettings()
            return
        }
        switch permission {
        case .pushNotifications:
            requestPushNotificationsPermission()
        }
    }
}
    
// MARK: - Push Notifications

extension UNAuthorizationStatus {
    var map: Permission.Status {
        switch self {
        case .denied: return .denied
        case .authorized: return .granted
        case .notDetermined, .provisional, .ephemeral: return .notRequested
        @unknown default: return .notRequested
        }
    }
}

private extension RealUserPermissionsUseCase {
    
    func pushNotificationsPermissionStatus(_ resolve: @escaping (Permission.Status) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                resolve(settings.authorizationStatus.map)
            }
        }
    }
    
    func requestPushNotificationsPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (isGranted, error) in
            DispatchQueue.main.async {
                self.appState[\.permissions.push] = isGranted ? .granted : .denied
            }
        }
    }
}

// MARK: -

final class StubUserPermissionsUseCase: UserPermissionsUseCase {
    
    func resolveStatus(for permission: Permission) {
    }
    func request(permission: Permission) {
    }
}
