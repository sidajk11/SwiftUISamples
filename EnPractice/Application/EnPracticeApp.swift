//
//  EnPracticeApp.swift
//  EnPractice
//
//  Created by 정영민 on 2024/05/31.
//

import SwiftUI

@main
struct EnPracticeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    
    @StateObject private var appRootManager = AppRootManager()

    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .intro:
                    IntroView(viewModel: .init(dependency: .init(container: appDelegate.environment.container)))
                case .main:
                    MainView(viewModel: .init(dependency: .init(container: appDelegate.environment.container)))
                }
            }
            .environmentObject(appRootManager)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
