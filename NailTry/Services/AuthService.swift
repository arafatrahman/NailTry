// Services/AuthService.swift
import Foundation
import FirebaseAuth
import Combine // Required for ObservableObject

class AuthService: ObservableObject {
    @Published var user: User?
    
    // We store the listener handle so we can clean it up if needed
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // Start listening for login/logout changes
    func listenToAuthChanges() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            print("👤 User Auth State Changed: \(user?.uid ?? "Logged Out")")
            DispatchQueue.main.async {
                self?.user = user
            }
        }
    }
    
    // Login function with completion handler (Success/Fail)
    func signInAnonymously(completion: @escaping (Error?) -> Void) {
        print("🔐 Attempting Anonymous Sign In...")
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("❌ Sign In Error: \(error.localizedDescription)")
                completion(error) // Send error back to View
            } else {
                print("✅ Sign In Success! User ID: \(result?.user.uid ?? "Unknown")")
                completion(nil) // Success (no error)
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Sign out error: \(error.localizedDescription)")
        }
    }
}
