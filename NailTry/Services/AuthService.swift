// Services/AuthService.swift
import Foundation
import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    @Published var user: User?
    @Published var isGuest: Bool = false
    @Published var isPremium: Bool = false // New: Tracks subscription status
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.user = Auth.auth().currentUser
        self.isGuest = self.user?.isAnonymous ?? false
    }
    
    func listenToAuthChanges() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            DispatchQueue.main.async {
                self?.user = user
                self?.isGuest = user?.isAnonymous ?? false
                // Logic to determine premium status can go here later (e.g. check Firestore)
                // For now, it defaults to false (Free)
            }
        }
    }
    
    // MARK: - Email / Password Auth
    
    func signUp(email: String, pass: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pass) { result, error in
            completion(error)
        }
    }
    
    func signIn(email: String, pass: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { result, error in
            completion(error)
        }
    }
    
    // MARK: - Guest & Sign Out
    
    func signInAnonymously(completion: @escaping (Error?) -> Void) {
        Auth.auth().signInAnonymously { result, error in
            completion(error)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isPremium = false // Reset premium on sign out
        } catch {
            print("❌ Sign out error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Account Deletion
    
    func deleteAccount(completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error = error {
                completion(error)
            } else {
                self.signOut()
                completion(nil)
            }
        }
    }
}
