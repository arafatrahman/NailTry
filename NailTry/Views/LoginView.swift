// Views/LoginView.swift
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            // Background
            Color.pink.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 30) {
                // --- Logo Area ---
                VStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundColor(.pink)
                    
                    Text("NailTry")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    
                    Text("Virtual Nail Salon")
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                
                Spacer()
                
                // --- Error Message Display ---
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
                
                // --- Buttons ---
                if isLoading {
                    ProgressView("Signing in...")
                        .tint(.pink)
                } else {
                    VStack(spacing: 16) {
                        // 1. Apple Sign In
                        SignInWithAppleButton(.signIn) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            switch result {
                            case .success(_):
                                print("Apple Login Successful")
                                // Real app: Pass credentials to Firebase here
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                        .frame(height: 50)
                        .frame(maxWidth: 375) // 👈 FIX: Apple strictly limits width to 375 max
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // 2. Guest Login
                        Button(action: handleGuestLogin) {
                            Text("Continue as Guest")
                                .font(.headline)
                                .foregroundColor(.pink)
                                .frame(maxWidth: .infinity) // Standard buttons can stretch infinitely
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                        }
                        .frame(maxWidth: 375) // Match the Apple button width for symmetry
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    // Logic to handle the Guest button tap
    func handleGuestLogin() {
        print("👆 Guest button tapped")
        isLoading = true
        errorMessage = nil
        
        // Call service with completion handler
        authService.signInAnonymously { error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
