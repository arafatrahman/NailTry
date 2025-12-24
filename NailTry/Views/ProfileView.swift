// Views/ProfileView.swift
import SwiftUI
import FirebaseAuth // 👈 Added this import to fix the 'email' property error

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showPremium = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            // Now accessible because FirebaseAuth is imported
                            Text(authService.user?.email ?? "Guest User")
                                .font(.headline)
                            
                            if authService.isGuest {
                                Text("Anonymous Account")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Subscription")) {
                    HStack {
                        Label("Premium Status", systemImage: "crown.fill")
                            .foregroundColor(.yellow)
                        Spacer()
                        Text("Free")
                            .foregroundColor(.gray)
                    }
                    
                    Button("Upgrade to Premium") {
                        showPremium = true
                    }
                    .foregroundColor(.pink)
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Privacy Policy")) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    Button(action: {
                        // Clear cache logic placeholder
                    }) {
                        Label("Clear Cache", systemImage: "trash")
                    }
                }
                
                Section {
                    Button(action: { authService.signOut() }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showPremium) {
                PremiumView()
            }
        }
    }
}

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
