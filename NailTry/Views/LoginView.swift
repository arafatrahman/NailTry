// Views/LoginView.swift
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pink.opacity(0.05).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        VStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundColor(.pink)
                            Text("NailTry")
                                .font(.largeTitle)
                                .bold()
                        }
                        .padding(.top, 40)
                        
                        // Picker
                        Picker("Mode", selection: $isLoginMode) {
                            Text("Log In").tag(true)
                            Text("Register").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // Fields
                        VStack(spacing: 15) {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        if let error = errorMessage {
                            Text(error).foregroundColor(.red).font(.caption)
                        }
                        
                        // Action Button
                        Button(action: handleEmailAuth) {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text(isLoginMode ? "Log In" : "Create Account")
                                    .bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        
                        Text("OR").foregroundColor(.gray).font(.caption)
                        
                        // Apple Sign In
                        SignInWithAppleButton(.signIn) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            // Handle Apple Auth (Placeholder)
                            print("Apple Sign In Result: \(result)")
                        }
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Guest
                        Button("Continue as Guest") {
                            authService.signInAnonymously { _ in }
                        }
                        .foregroundColor(.gray)
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func handleEmailAuth() {
        isLoading = true
        errorMessage = nil
        
        if isLoginMode {
            authService.signIn(email: email, pass: password) { error in
                isLoading = false
                if let error = error { errorMessage = error.localizedDescription }
            }
        } else {
            authService.signUp(email: email, pass: password) { error in
                isLoading = false
                if let error = error { errorMessage = error.localizedDescription }
            }
        }
    }
}
