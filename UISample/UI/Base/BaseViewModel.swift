//
//  BaseViewModel.swift
//  UISample
//
//  Created by 정영민 on 7/20/24.
//

import SwiftUI
import Combine

class BaseViewModel: ObservableObject, Identifiable {
    typealias ID = UUID
    
    let id: UUID = UUID()
    
    let container: DIContainer
    let cancelBag = CancelBag()
    
    @Published var isAppeared: Bool = false
    
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

extension BaseViewModel: Hashable {
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
