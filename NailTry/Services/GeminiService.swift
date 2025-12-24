// Services/GeminiService.swift
import Foundation
import UIKit
import GoogleGenerativeAI

class GeminiService {
    private let model: GenerativeModel

    init() {
        // ⚠️ FIX: Use the specific version "gemini-1.5-flash-001"
        // This is the stable release identifier and resolves 404 errors.
        self.model = GenerativeModel(name: "gemini-2.5-flash-image", apiKey: Configuration.geminiAPIKey)
    }

    func generateNailPreview(originalImage: UIImage, designPrompt: String) async throws -> UIImage {
        // 1. Resize image (Max 1024px) for speed and to fit model limits
        guard let resizedImage = originalImage.resized(to: 1024) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to resize image"])
        }

        // 2. Stronger Prompt
        let prompt = """
        Role: Professional Nail Artist.
        Task: Realistic Virtual Try-On.
        Input: Photo of a hand.
        Instructions: 
        - Replace the nail polish with this style: "\(designPrompt)".
        - MAINTAIN the exact hand shape, skin texture, lighting, and background.
        - The output must look like a real photo, not a cartoon.
        - Return ONLY the image.
        """

        // 3. API Call
        do {
            let response = try await model.generateContent(prompt, resizedImage)

            // 4. Decode Response
            if let imagePart = response.candidates.first?.content.parts.first(where: {
                if case .data = $0 { return true }; return false
            }),
               case let .data(_, data) = imagePart,
               let finalImage = UIImage(data: data) {
                return finalImage
            } else {
                throw NSError(domain: "AIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "AI finished but returned no image. It might have been blocked by safety settings."])
            }
        } catch {
            print("❌ Gemini API Error: \(error)")
            throw error
        }
    }
}

// Image Resizing Helper
extension UIImage {
    func resized(to maxDim: CGFloat) -> UIImage? {
        let ratio = size.width / size.height
        let newSize = size.width > size.height
            ? CGSize(width: maxDim, height: maxDim / ratio)
            : CGSize(width: maxDim * ratio, height: maxDim)
        
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
