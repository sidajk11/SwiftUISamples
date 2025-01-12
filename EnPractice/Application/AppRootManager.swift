//
//  AppRootManager.swift
//  EnPractice
//
//  Created by 정영민 on 2024/08/02.
//

import Foundation

final class AppRootManager: ObservableObject {
    
    @Published var currentRoot: AppRoots = .intro
    
    enum AppRoots {
        case intro
        case main
    }
}
