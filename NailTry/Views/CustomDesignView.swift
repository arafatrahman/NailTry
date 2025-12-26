// Views/CustomDesignView.swift
import SwiftUI
import PhotosUI

struct CustomDesignView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authService: AuthService
    
    // State for Images
    @State private var handImage: UIImage?
    @State private var styleImage: UIImage?
    @State private var generatedImage: UIImage?
    
    // State for Pickers
    @State private var showHandPicker = false
    @State private var showStylePicker = false
    @State private var handItem: PhotosPickerItem?
    @State private var styleItem: PhotosPickerItem?
    
    // State for UI
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    private let aiService = GeminiService()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Custom Studio")
                        .font(.headline)
                    Spacer()
                    // Reset Button
                    if generatedImage != nil {
                        Button("Reset") {
                            withAnimation { generatedImage = nil }
                        }
                    } else {
                        Spacer().frame(width: 40)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // 1. Result Area
                        if let result = generatedImage, let original = handImage {
                            VStack(alignment: .leading) {
                                Text("Your Result")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                // Reusing the slider from NailDetailView.swift
                                // Ensure NailDetailView.swift is compiled in the same target
                                SmoothBeforeAfterSlider(before: original, after: result)
                                    .frame(height: 400)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(radius: 5)
                                    .padding(.horizontal)
                                
                                HStack(spacing: 20) {
                                    ActionButton(icon: "arrow.down.circle.fill", text: "Save", color: .gray.opacity(0.1), textColor: .primary) {
                                        UIImageWriteToSavedPhotosAlbum(result, nil, nil, nil)
                                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                                    }
                                    
                                    ActionButton(icon: "square.and.arrow.up.fill", text: "Share", color: .pink, textColor: .white) {
                                        shareImage(image: result)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            
                            // 2. Input Section
                            VStack(spacing: 20) {
                                Text("Create your own style")
                                    .font(.title2)
                                    .bold()
                                
                                Text("Upload a photo of your hand and a reference image of the nail design you want to try.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                // Hand Picker
                                UploadCard(
                                    title: "1. Your Hand",
                                    icon: "hand.raised.fill",
                                    image: handImage,
                                    action: { showHandPicker = true }
                                )
                                
                                // Style Picker
                                UploadCard(
                                    title: "2. Style Reference",
                                    icon: "paintpalette.fill",
                                    image: styleImage,
                                    action: { showStylePicker = true }
                                )
                            }
                            .padding(.horizontal)
                            
                            // 3. Generate Button
                            Button(action: generateCustomDesign) {
                                HStack {
                                    Image(systemName: "wand.and.stars")
                                    Text("Generate Design")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((handImage != nil && styleImage != nil) ? Color.pink : Color.gray)
                                .cornerRadius(16)
                                .shadow(radius: 5)
                            }
                            .disabled(handImage == nil || styleImage == nil || isLoading)
                            .padding()
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
            
            // Loading Overlay
            if isLoading {
                MagicGradientLoader()
                    .zIndex(100)
            }
        }
        .navigationBarHidden(true)
        // Picker Sheets
        .photosPicker(isPresented: $showHandPicker, selection: $handItem, matching: .images)
        .photosPicker(isPresented: $showStylePicker, selection: $styleItem, matching: .images)
        // Hand Handler
        .onChange(of: handItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run { handImage = uiImage }
                }
            }
        }
        // Style Handler
        .onChange(of: styleItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run { styleImage = uiImage }
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
    }
    
    // Logic
    func generateCustomDesign() {
        guard let hand = handImage, let style = styleImage else { return }
        
        isLoading = true
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        Task {
            do {
                let result = try await aiService.generateCustomNailPreview(
                    handImage: hand,
                    styleImage: style,
                    isPremium: authService.isPremium
                )
                
                await MainActor.run {
                    withAnimation {
                        generatedImage = result
                        isLoading = false
                    }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                }
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
    
    func shareImage(image: UIImage) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// Subcomponent for Upload Cards
struct UploadCard: View {
    let title: String
    let icon: String
    let image: UIImage?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundColor(.gray.opacity(0.3))
                        )
                    
                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        VStack {
                            Image(systemName: icon)
                                .font(.system(size: 30))
                                .foregroundColor(.pink)
                            Text("Tap to Select")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}
