// Views/ProfileView.swift
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showPremium = false
    @State private var showingDeleteAlert = false
    @State private var deleteErrorMessage: String?
    
    var body: some View {
        NavigationView {
            List {
                // Section 1: User Info
                Section(header: Text("Account")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authService.user?.email ?? "Guest User")
                                .font(.headline)
                            
                            if authService.isGuest {
                                Text("Anonymous Account")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(4)
                            } else {
                                Text("Free Member")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Section 2: Premium Benefits List
                Section(header: Text("Premium Benefits")) {
                    Button(action: { showPremium = true }) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Label("Upgrade to Premium", systemImage: "crown.fill")
                                    .font(.headline)
                                    .foregroundColor(.pink)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            
                            // Bullet points
                            VStack(alignment: .leading, spacing: 5) {
                                BenefitPoint(text: "Unlimited AI Try-On generations")
                                BenefitPoint(text: "Upload your own custom styles") // Added Feature
                                BenefitPoint(text: "Access to exclusive seasonal designs")
                                BenefitPoint(text: "High-resolution downloads")
                                BenefitPoint(text: "Priority processing speed")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                // Section 3: Danger Zone
                Section(header: Text("Danger Zone")) {
                    Button(action: { authService.signOut() }) {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        Label("Delete Account", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showPremium) {
                PremiumView()
            }
            .alert("Delete Account", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
            } message: {
                Text("Are you sure? This action cannot be undone and all your data will be permanently lost.")
            }
            .alert("Error", isPresented: .constant(deleteErrorMessage != nil)) {
                Button("OK") { deleteErrorMessage = nil }
            } message: {
                Text(deleteErrorMessage ?? "Unknown error")
            }
        }
    }
    
    func deleteAccount() {
        authService.deleteAccount { error in
            if let error = error {
                deleteErrorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - Premium Sheet View
struct PremiumView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "crown.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)
            
            Text("Go Premium")
                .font(.largeTitle)
                .bold()
            
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "infinity", text: "Unlimited Styles")
                FeatureRow(icon: "paintpalette.fill", text: "Design Your Own (Upload)") // Added Feature
                FeatureRow(icon: "bolt.fill", text: "Fast AI Generation")
                FeatureRow(icon: "star.fill", text: "Exclusive Designs")
            }
            .padding()
            
            Spacer()
            
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Subscribe - $4.99/mo")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
        .padding(.top, 50)
    }
}

// MARK: - Helper Components

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .frame(width: 30)
            Text(text)
                .font(.headline)
        }
    }
}

struct BenefitPoint: View {
    let text: String
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 12))
                .padding(.top, 2)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
