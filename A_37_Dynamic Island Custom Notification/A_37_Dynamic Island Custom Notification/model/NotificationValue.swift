//
//  NotificationValue.swift
//  A_37_Dynamic Island Custom Notification
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI
import UserNotifications

struct NotificationValue: Identifiable {
    var id = UUID().uuidString
    var content: UNNotificationContent
    var dateCreated: Date = .init()
    var showNotification: Bool = false
    
    
}
