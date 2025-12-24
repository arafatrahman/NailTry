// Views/RootView.swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        if authService.user != nil {
            HomeView()
        } else {
            LoginView()
        }
    }
}
