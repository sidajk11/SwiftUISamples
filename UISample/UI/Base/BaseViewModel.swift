//
//  BaseViewModel.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject, Identifiable {
    let container: DIContainer
    let cancelBag = CancelBag()
    
    static var preview: Self {
        .init(container: .preview)
    }
    
    required init(container: DIContainer) {
        self.container = container
    }
    
    convenience init(baseViewModel: BaseViewModel) {
        self.init(container: baseViewModel.container)
    }
}
