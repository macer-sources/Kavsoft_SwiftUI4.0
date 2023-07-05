//
//  ContentView.swift
//  A_37_Dynamic Island Custom Notification
//
//  Created by Kan Tao on 2023/7/5.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        Text("In App Push Notifications \n Using Dynamic Inland")
            .font(.title)
            .fontWeight(.semibold)
            .lineSpacing(12)
            .kerning(1.1)
            .multilineTextAlignment(.center)
            .onAppear {
                authorizeNotification()
            }
    }
    
    
    // MARK: Notification request
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge,.sound]) { _, _ in
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
