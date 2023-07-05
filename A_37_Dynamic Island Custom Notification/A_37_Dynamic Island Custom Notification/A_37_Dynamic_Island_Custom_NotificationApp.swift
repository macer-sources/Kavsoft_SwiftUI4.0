//
//  A_37_Dynamic_Island_Custom_NotificationApp.swift
//  A_37_Dynamic Island Custom Notification
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI
import UserNotifications

@main
struct A_37_Dynamic_Island_Custom_Notification_sApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: App Delegate to listen for in app notifications
class AppDelegate: NSObject, UIApplicationDelegate,UNUserNotificationCenterDelegate  {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        if UIApplication.shared.haveDynamicIsland {
            return [.sound]
        }else {
            return [.sound, .banner]
        }
    }
}


extension UIApplication {
    var haveDynamicIsland:Bool {
        return deviceName == "iPhone 14 Pro" || deviceName == "iPhone 14 Pro Max"
    }
    var deviceName: String {
        return UIDevice.current.name
    }
}


