// Services/AuthService.swift
import Foundation
import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    @Published var user: User?
    @Published var isGuest: Bool = false
    
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
        } catch {
            print("❌ Sign out error: \(error.localizedDescription)")
        }
    }
}
