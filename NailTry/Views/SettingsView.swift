// Views/SettingsView.swift
import SwiftUI

struct SettingsView: View {
    // Persistent Storage
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("useFaceID") private var useFaceID = false
    
    @State private var showingClearCacheAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Preferences
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                            .foregroundColor(.purple)
                    }
                    Toggle(isOn: $notificationsEnabled) {
                        Label("Notifications", systemImage: "bell.fill")
                            .foregroundColor(.red)
                    }
                }
                
                // MARK: - Support
                Section(header: Text("Support")) {
                    NavigationLink(destination: HelpCenterView()) {
                        Label("Help Center", systemImage: "questionmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://apps.apple.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label("Rate NailTry", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                
                // MARK: - Data
                Section(header: Text("Data & Storage")) {
                    Button(action: {
                        clearAppCache()
                        showingClearCacheAlert = true
                    }) {
                        Label("Clear Cache & Data", systemImage: "trash.fill")
                            .foregroundColor(.orange)
                    }
                }
                
                // MARK: - Legal
                Section(header: Text("About")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                    }
                    
                    HStack {
                        Label("Version", systemImage: "info.circle.fill")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())
            .alert("Cache Cleared", isPresented: $showingClearCacheAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Local images and temporary data have been successfully deleted.")
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    // MARK: - Logic
    func clearAppCache() {
        URLCache.shared.removeAllCachedResponses()
        let fileManager = FileManager.default
        if let tmpDir = try? fileManager.contentsOfDirectory(atPath: NSTemporaryDirectory()) {
            for file in tmpDir {
                try? fileManager.removeItem(atPath: NSTemporaryDirectory() + file)
            }
        }
        print("✅ Cache Cleared")
    }
}

// MARK: - Subviews

struct HelpCenterView: View {
    @State private var showingMailError = false
    
    var body: some View {
        Form {
            Section(header: Text("Contact Us")) {
                Text("Need help? Send us a message directly.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: openMail) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Email Support (hi@webbird.com)")
                    }
                    .foregroundColor(.blue)
                }
                .alert("No Mail App Found", isPresented: $showingMailError) {
                    Button("Copy Email") {
                        UIPasteboard.general.string = "hi@webbird.com"
                    }
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("We couldn't open the Mail app (common on Simulator). The email 'hi@webbird.com' is ready to be copied.")
                }
            }
            
            Section(header: Text("FAQ")) {
                DisclosureGroup("How do I upload a photo?") {
                    Text("Go to the detail page of any design and tap the camera icon.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                DisclosureGroup("Is it free?") {
                    Text("Yes! You can try basic designs for free. Premium unlocks unlimited styles.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Help Center")
    }
    
    func openMail() {
        let email = "hi@webbird.com"
        let subject = "NailTry Support Request"
        let body = "Hello Developer,"
        
        // Construct the URL safely
        let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // Fallback: Show alert if on Simulator or no mail app
                showingMailError = true
            }
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                
                Text("Last updated: December 2025")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("1. Data Collection")
                    .font(.headline)
                Text("We collect minimal data necessary to provide our services. This includes photos you upload for virtual try-on, which are processed temporarily and not permanently stored on our servers without your permission.")
                
                Text("2. Image Usage")
                    .font(.headline)
                Text("Images uploaded for AI processing are sent to our secure inference engine (Gemini API) and are discarded immediately after processing.")
                
                Text("3. Contact")
                    .font(.headline)
                Text("For privacy concerns, contact hi@webbird.com.")
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Terms of Service")
                    .font(.largeTitle)
                    .bold()
                
                Text("1. Acceptance")
                    .font(.headline)
                Text("By using NailTry, you agree to these terms.")
                
                Text("2. Usage")
                    .font(.headline)
                Text("You agree not to upload illegal or offensive content. We reserve the right to ban users who violate this policy.")
                
                Text("3. Liability")
                    .font(.headline)
                Text("NailTry is provided 'as is'. We are not liable for any data loss or issues arising from the use of the app.")
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
