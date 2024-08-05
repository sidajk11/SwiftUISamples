//
//  BaseViewModel.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    let container: DIContainer
    @Published var navRouter = NavigationRouter()
    let cancelBag = CancelBag()
    
    static var preview: Self {
        .init(container: .preview)
    }
    
    required init(container: DIContainer, navRouter: NavigationRouter? = nil) {
        self.container = container
        if let navRouter = navRouter {
            self.navRouter = navRouter
        }
    }
    
    convenience init(baseViewModel: BaseViewModel) {
        self.init(container: baseViewModel.container, navRouter: baseViewModel.navRouter)
    }
}
