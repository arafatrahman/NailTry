// Views/NailDetailView.swift
import SwiftUI
import PhotosUI

struct NailDetailView: View {
    let design: NailDesign
    @State private var inputImage: UIImage?
    @State private var generatedImage: UIImage?
    @State private var isLoading = false
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    
    private let aiService = GeminiService()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 1. Design Image
                AsyncImage(url: URL(string: design.imageUrl)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 300)
                .clipped()
                
                // 2. Info
                VStack(alignment: .leading, spacing: 10) {
                    Text(design.name)
                        .font(.title)
                        .bold()
                    
                    Text(design.category)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.pink.opacity(0.1))
                        .foregroundColor(.pink)
                        .cornerRadius(8)
                    
                    Text("Description")
                        .font(.headline)
                        .padding(.top)
                    Text("A beautiful \(design.name) style perfect for \(design.category) occasions.")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // 3. Try On Section
                VStack(spacing: 15) {
                    Text("Virtual Try-On")
                        .font(.headline)
                    
                    if let result = generatedImage, let original = inputImage {
                        // Comparison View (Simple Toggle for now, or use ZStack with slider logic)
                        VStack {
                            Image(uiImage: result)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .overlay(
                                    Text("AI Generated")
                                        .padding(5)
                                        .background(Color.black.opacity(0.6))
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                        .padding(8),
                                    alignment: .topLeading
                                )
                            
                            HStack {
                                Button("Save") {
                                    UIImageWriteToSavedPhotosAlbum(result, nil, nil, nil)
                                }
                                Spacer()
                                Button("Share") {
                                    shareImage(image: result)
                                }
                            }
                            .padding()
                        }
                    } else if let original = inputImage {
                        Image(uiImage: original)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .frame(height: 300)
                        
                        Button(action: generatePreview) {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Label("Generate Preview", systemImage: "wand.and.stars")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(isLoading)
                        
                    } else {
                        // Upload Box
                        Button(action: { showImagePicker = true }) {
                            VStack(spacing: 15) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 40))
                                Text("Upload Hand Photo")
                                    .font(.headline)
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.inputImage = uiImage
                    self.generatedImage = nil // Reset previous generation
                }
            }
        }
    }
    
    func generatePreview() {
        guard let hand = inputImage else { return }
        isLoading = true
        Task {
            do {
                let result = try await aiService.generateNailPreview(originalImage: hand, designPrompt: design.prompt)
                await MainActor.run {
                    generatedImage = result
                    isLoading = false
                }
            } catch {
                print("Generation error: \(error)")
                await MainActor.run { isLoading = false }
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
