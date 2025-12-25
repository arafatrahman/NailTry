// NailTryApp.swift
import SwiftUI
import FirebaseCore

// 1. Create a standard AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Request Notification Permissions on Launch
        NotificationManager.shared.requestPermission()
        
        return true
    }
}

@main
struct NailTryApp: App {
    // 2. Connect the Delegate to SwiftUI
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 3. Initialize AuthService
    @StateObject var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authService)
                .onAppear {
                    authService.listenToAuthChanges()
                }
        }
    }
}
