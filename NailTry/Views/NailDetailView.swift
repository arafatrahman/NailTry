// Views/NailDetailView.swift
import SwiftUI
import PhotosUI

struct NailDetailView: View {
    let design: NailDesign
    @State private var inputImage: UIImage?
    @State private var generatedImage: UIImage?
    @State private var isLoading = false
    @State private var selectedItem: PhotosPickerItem?
    
    // Initialize our Gemini Service
    private let aiService = GeminiService()
    
    var body: some View {
        VStack(spacing: 20) {
            // Preview Area
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                
                if let result = generatedImage {
                    Image(uiImage: result).resizable().scaledToFit().cornerRadius(16)
                } else if let original = inputImage {
                    Image(uiImage: original).resizable().scaledToFit().cornerRadius(16)
                } else {
                    VStack {
                        Image(systemName: "camera").font(.largeTitle).foregroundColor(.gray)
                        Text("Upload Hand Photo").foregroundColor(.gray)
                    }
                }
                
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.3).cornerRadius(16)
                        ProgressView().tint(.white)
                    }
                }
            }
            .frame(height: 400)
            .padding()
            
            // Controls
            HStack(spacing: 20) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Upload", systemImage: "photo.on.rectangle")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                
                if inputImage != nil {
                    Button(action: generate) {
                        Label("Try On", systemImage: "wand.and.stars")
                            .padding()
                            .background(isLoading ? Color.gray : Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(isLoading)
                }
            }
        }
        .navigationTitle(design.name)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.inputImage = uiImage
                    self.generatedImage = nil
                }
            }
        }
    }
    
    func generate() {
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
                print("Error: \(error)")
                await MainActor.run { isLoading = false }
            }
        }
    }
}
