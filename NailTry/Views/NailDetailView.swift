// Views/NailDetailView.swift
import SwiftUI
import PhotosUI

struct NailDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    // CHANGED: Access AuthService to check premium status
    @EnvironmentObject var authService: AuthService
    
    let design: NailDesign
    @State private var inputImage: UIImage?
    @State private var generatedImage: UIImage?
    @State private var isLoading = false
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    // Services
    private let aiService = GeminiService()
    
    var body: some View {
        ZStack {
            // 1. Clean Background
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 2. Custom Header Row
                HStack(spacing: 16) {
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Text("Trying: \(design.name)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Reset Canvas Button (Upper Right)
                    if generatedImage != nil || inputImage != nil {
                        Button(action: {
                            withAnimation {
                                generatedImage = nil
                                inputImage = nil
                            }
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 15)
                
                // 3. Main Workspace
                ZStack {
                    if let result = generatedImage, let original = inputImage {
                        // STATE: Result (Before/After Slider)
                        VStack {
                            // Slider takes up available space
                            SmoothBeforeAfterSlider(before: original, after: result)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            // Bottom Controls
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
                            .padding(.bottom, 30) // Extra bottom padding
                            .padding(.top, 20)
                        }
                        
                    } else if let original = inputImage {
                        // STATE: Preview (Ready to Generate)
                        VStack {
                            GeometryReader { geo in
                                Image(uiImage: original)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .shadow(radius: 5)
                            }
                            .padding(.horizontal)
                            .frame(maxHeight: .infinity)
                            .overlay(
                                Button(action: { showImagePicker = true }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                        .padding()
                                },
                                alignment: .topTrailing
                            )
                            
                            // Magic Generate Button
                            Button(action: generatePreview) {
                                HStack(spacing: 12) {
                                    Image(systemName: "sparkles")
                                    Text("Apply Magic")
                                }
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(colors: [.purple, .pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(color: .pink.opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                            .padding(.top, 20)
                        }
                        
                    } else {
                        // STATE: Upload (Empty)
                        Button(action: { showImagePicker = true }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.gray.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                            .foregroundColor(.gray.opacity(0.3))
                                    )
                                
                                VStack(spacing: 20) {
                                    Circle()
                                        .fill(Color.pink.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 36))
                                                .foregroundColor(.pink)
                                        )
                                    
                                    VStack(spacing: 8) {
                                        Text("Upload Hand Photo")
                                            .font(.title3)
                                            .bold()
                                            .foregroundColor(.primary)
                                        
                                        Text("Tap to open library")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding(24)
                    }
                }
            }
            
            // 4. Magic Loading Overlay
            if isLoading {
                MagicGradientLoader()
                    .transition(.opacity)
                    .zIndex(100)
            }
        }
        .navigationBarHidden(true)
        .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.inputImage = uiImage
                        self.generatedImage = nil
                    }
                }
            }
        }
    }
    
    // MARK: - Logic
    
    func generatePreview() {
        guard let hand = inputImage else { return }
        isLoading = true
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        Task {
            do {
                // CHANGED: Pass isPremium to GeminiService
                let result = try await aiService.generateNailPreview(
                    originalImage: hand,
                    designPrompt: design.prompt,
                    isPremium: authService.isPremium
                )
                
                await MainActor.run {
                    withAnimation(.easeOut(duration: 0.5)) {
                        generatedImage = result
                        isLoading = false
                    }
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
            } catch {
                print("Generation error: \(error)")
                await MainActor.run { isLoading = false }
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

// MARK: - Components

struct ActionButton: View {
    let icon: String
    let text: String
    let color: Color
    let textColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(text)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(textColor)
            .cornerRadius(16)
        }
    }
}

// MARK: - Improved Slider
struct SmoothBeforeAfterSlider: View {
    let before: UIImage
    let after: UIImage
    
    @State private var offset: CGFloat = 0.5
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            ZStack {
                // Background (Original)
                Image(uiImage: before)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .overlay(
                        Text("Original")
                            .font(.caption)
                            .bold()
                            .padding(6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(6)
                            .padding(10)
                            .opacity(offset > 0.05 ? 1 : 0),
                        alignment: .topLeading
                    )
                
                // Foreground (AI Result) - Masked
                Image(uiImage: after)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .mask(
                        HStack(spacing: 0) {
                            Rectangle().frame(width: max(0, width * offset))
                            Spacer(minLength: 0)
                        }
                    )
                    .overlay(
                        Text("Generated")
                            .font(.caption)
                            .bold()
                            .padding(6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(6)
                            .padding(10)
                            .opacity(offset < 0.95 ? 1 : 0),
                        alignment: .topTrailing
                    )
                
                // Handle Line
                Rectangle()
                    .fill(.white)
                    .frame(width: 2)
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.2), radius: 4)
                            Image(systemName: "arrow.left.and.right")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.black)
                        }
                    )
                    .offset(x: (width * offset) - (width / 2))
            }
            // Gesture applied to the CONTAINER, not the handle
            .contentShape(Rectangle()) // Ensures the entire area catches the drag
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // Calculate offset strictly relative to the frame width
                        let newOffset = value.location.x / width
                        withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.8)) {
                            self.offset = min(max(newOffset, 0), 1)
                        }
                    }
            )
        }
    }
}

// Gradient Loader
struct MagicGradientLoader: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()
            
            ZStack {
                Circle()
                    .fill(
                        AngularGradient(gradient: Gradient(colors: [.red, .purple, .blue, .green, .yellow, .red]), center: .center)
                    )
                    .frame(width: 200, height: 200)
                    .blur(radius: 40)
                    .rotationEffect(.degrees(rotation))
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 150, height: 150)
                    .blur(radius: 20)
            }
            .scaleEffect(scale)
            
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .symbolEffect(.bounce, options: .repeating)
                
                Text("Creating Magic...")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Applying design with AI")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
        }
    }
}
