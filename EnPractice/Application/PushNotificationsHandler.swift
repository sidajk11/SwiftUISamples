//
//  PushNotificationsHandler.swift
//  EnPractice
//
//  Created by 정영민 on 2024/06/13.
//
import UserNotifications

protocol PushNotificationsHandler { }

class RealPushNotificationsHandler: NSObject, PushNotificationsHandler {
    
    private let deepLinksHandler: DeepLinksHandler
    
    init(deepLinksHandler: DeepLinksHandler) {
        self.deepLinksHandler = deepLinksHandler
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension RealPushNotificationsHandler: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo: userInfo, completionHandler: completionHandler)
    }
    
    func handleNotification(userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        guard let payload = userInfo["aps"] as? NotificationPayload else {
            completionHandler()
            return
        }
        deepLinksHandler.open(deepLink: .showMain)
        completionHandler()
    }
}
