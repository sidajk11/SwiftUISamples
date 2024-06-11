//
//  UISampleApp.swift
//  UISample
//
//  Created by 정영민 on 2024/05/31.
//

import SwiftUI

@main
struct UISampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
