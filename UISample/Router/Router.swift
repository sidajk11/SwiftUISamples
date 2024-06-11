//
//  Router.swift
//  UISample
//
//  Created by 정영민 on 2024/06/11.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigateTo<T: Hashable>(route: T) {
        path.append(route)
    }
    
    func popup() {
        path.removeLast()
    }
    
    func popup(_ k: Int) {
        path.removeLast(k)
    }
}
