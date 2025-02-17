//
//  AppState.swift
//  EnPractice
//
//  Created by 정영민 on 7/20/24.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var system = System()
    var permissions = Permissions()
}

extension AppState {
    struct UserData: Equatable {
        var token: String = ""
    }
}

extension AppState.UserData {
    var isLogined: Bool {
        return !token.isEmpty
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

extension AppState {
    struct Permissions: Equatable {
        var push: Permission.Status = .unknown
    }
    
    static func permissionKeyPath(for permission: Permission) -> WritableKeyPath<AppState, Permission.Status> {
        let pathToPermissions = \AppState.permissions
        switch permission {
        case .pushNotifications:
            return pathToPermissions.appending(path: \.push)
        }
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
        lhs.system == rhs.system &&
        lhs.permissions == rhs.permissions
}


#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
}
#endif
