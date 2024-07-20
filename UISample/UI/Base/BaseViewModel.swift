//
//  BaseViewModel.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    let container: DIContainer
    let cancelBag = CancelBag()
    
    init(container: DIContainer) {
        self.container = container
    }
}
