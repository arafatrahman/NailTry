// Views/RootView.swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject var authService: AuthService
    // default is false (User hasn't seen it yet)
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation { showSplash = false }
                        }
                    }
            } else if !hasSeenOnboarding {
                // Pass the binding. When OnboardingView sets this to true, this block will hide.
                OnboardingView(isOnboardingCompleted: $hasSeenOnboarding)
            } else if authService.user != nil {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
