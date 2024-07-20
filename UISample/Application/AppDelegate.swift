//
//  AppDelegate.swift
//  UISample
//
//  Created by 정영민 on 2024/06/11.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    var systemEventsHandler: SystemEventsHandler!
    var environment: AppEnvironment!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        environment = AppEnvironment.bootstrap()
        self.systemEventsHandler = environment.systemEventsHandler
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        systemEventsHandler?.handle(url: url)
        return true
    }
}
