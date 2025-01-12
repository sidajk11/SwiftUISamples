//
//  Router.swift
//  EnPractice
//
//  Created by 정영민 on 2024/06/11.
//

import SwiftUI

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push<T: Routable>(route: T) {
        path.append(route)
    }
    
    func popup() {
        path.removeLast()
    }
    
    func popup(_ k: Int) {
        path.removeLast(k)
    }
    
    func popupToRoot() {
        path.removeLast(path.count)
    }
}

class PresentRouter<T: Routable>: ObservableObject {
    
    @Published public var sheet: T?
    @Published public var fullScreen: T?
    @Published public var popup: T?
    
    func sheet(route: T) {
        sheet = route
    }
    
    func fullScreenCover(route: T) {
        fullScreen = route
    }
    
    func popup(route: T) {
        popup = route
    }
}
