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
    
    @State var allNotifications:[NotificationValue] = []
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .top) {
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        ForEach(allNotifications) { notification in
                            NotificationPreview(size: size, value: notification, allNotifications: $allNotifications)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        }
                       
                    }
                    .ignoresSafeArea()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name.init("NOTIFY"))) { output in
                    if let content = output.userInfo?["content"] as? UNNotificationContent {
                        let newNotification = NotificationValue.init(content: content)
                        allNotifications.append(newNotification)
                    }
                }
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
            NotificationCenter.default.post(name: NSNotification.Name.init("NOTIFY"), object: nil, userInfo: [
                "content": notification.request.content
            ])
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


// MARK: Custom Notification View
struct NotificationPreview: View {
    var size: CGSize
    var value: NotificationValue
    @Binding var allNotifications:[NotificationValue]
    var body: some View {
        HStack {
            // MARK: Custom UI
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading,spacing: 8) {
                Text(value.content.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(value.content.body)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        .padding(10)
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        .blur(radius: value.showNotification ? 0 : 30)
        .opacity(value.showNotification ? 1 : 0)
        .scaleEffect(value.showNotification ? 1 : 0.5, anchor: .top)
        .frame(width: value.showNotification ? size.width - 22 :  126, height: value.showNotification ? nil :  37.33)
        .background {
            RoundedRectangle(cornerRadius: value.showNotification ? 50 : 63)
                .fill(.black)
        }
        .offset(y: 11)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: value.showNotification)
        // MARK: Auto close after some time
        .clipped()
        .onChange(of: value.showNotification, perform: { newValue in
            if newValue && allNotifications.indices.contains(index) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if allNotifications.indices.contains(index + 1) {
                        allNotifications[index + 1].showNotification = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        allNotifications[index].showNotification = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if allNotifications.indices.contains(index + 1) {
                                allNotifications[index + 1].showNotification = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            allNotifications.remove(at: index)
                        }
                    }
                }
            }
        })
        .onAppear {
            // MARK: Animating when a new notification
            if index == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    allNotifications[index].showNotification = true
                }
            }
        }
    }
    
    // MARK: Index
    var index: Int {
        return allNotifications.firstIndex { v  in
            value.id == v.id
        } ?? 0
    }
}
