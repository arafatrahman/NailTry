// Services/NotificationManager.swift
import Foundation
import UserNotifications
import UIKit // Needed for application icon badge numbers if used

class NotificationManager: NSObject {
    static let shared = NotificationManager()
    
    // Computed property to read the latest value directly from UserDefaults.
    // We use object(forKey:) to allow a default of 'true' if the setting hasn't been toggled yet.
    private var notificationsEnabled: Bool {
        UserDefaults.standard.object(forKey: "notificationsEnabled") as? Bool ?? true
    }
    
    override init() {
        super.init()
        // Set delegate to handle foreground notifications
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            } else {
                print("✅ Notification permission granted: \(granted)")
            }
        }
    }
    
    func sendNewStyleNotification(name: String, category: String) {
        // Check if user disabled notifications in Settings
        guard notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "New Style Added! 💅"
        content.body = "Check out the new '\(name)' in the \(category) category."
        content.sound = .default
        
        // Trigger immediately
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification: \(error)")
            }
        }
    }
}

// Allow notifications to show even when the app is in the foreground
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show Banner and Sound
        completionHandler([.banner, .sound])
    }
}
