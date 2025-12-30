// Services/GeminiService.swift
import Foundation
import UIKit

class GeminiService {
    private let apiKey = Configuration.geminiAPIKey
    // Using the stable, production model
    private let modelName = "gemini-2.5-flash-image"

    init() {}

    // MARK: - Standard Generation (Text Prompt)
    
    func generateNailPreview(originalImage: UIImage, designPrompt: String, isPremium: Bool) async throws -> UIImage {
        
        // 1. Resolution & Speed Logic
        // Free: 512px (Low Res), Premium: 1024px (High Res)
        let targetResolution: CGFloat = isPremium ? 1024 : 512
        
        // Free: Simulate "Standard" processing queue (Slower)
        if !isPremium {
            print("⏳ Free account: Simulating standard processing speed...")
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 second delay
        }
        
        // 2. Resize & Compress
        guard let resizedImage = originalImage.resized(to: targetResolution),
              let jpegData = resizedImage.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])
        }
        
        let base64Image = jpegData.base64EncodedString()

        // 3. Unified Style DNA Prompt (Texture Engine)
        let promptText = """
        Role: AI Texture Engine & Digital Manicurist.
        Task: Render specific material properties onto fingernails while strictly preserving the source environment.
        
        Input Analysis:
        - Source Image: User's hand photo (contains fixed lighting, skin tone, and perspective).
        - Material DNA: "\(designPrompt)"
        
        Execution Rules:
        1. **Material Synthesis**: Generate the texture defined in 'Material DNA' (e.g., gloss, opacity, metallic flecks, gradient) with photo-real accuracy.
        2. **Environmental Integration**: Do NOT generate new lighting. You must map the 'Material DNA' into the *existing* lighting of the Source Image. Specular highlights (reflections) and shadows must match the original photo exactly to maintain physical consistency.
        3. **Strict Masking**: Identify the nail plates with pixel-perfect precision. Do not alter cuticles, skin, fingers, or background.
        
        Output: The Source Image with ONLY the new Material DNA applied to the nails.
        """
        
        // 4. Request Body
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": promptText],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ],
            "safetySettings": [
                ["category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"],
                ["category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_ONLY_HIGH"],
                ["category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_ONLY_HIGH"],
                ["category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_ONLY_HIGH"]
            ]
        ]

        return try await performRequest(requestBody: requestBody, isPremium: isPremium)
    }
    
    // MARK: - Custom Design Generation (Image Reference)
    
    func generateCustomNailPreview(handImage: UIImage, styleImage: UIImage, isPremium: Bool) async throws -> UIImage {
        
        let targetResolution: CGFloat = isPremium ? 1024 : 512
        
        if !isPremium {
            print("⏳ Free account: Simulating standard processing speed...")
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        }
        
        // Resize Both Images
        guard let resizedHand = handImage.resized(to: targetResolution),
              let handData = resizedHand.jpegData(compressionQuality: 0.8),
              let resizedStyle = styleImage.resized(to: 512), // Style reference doesn't need to be huge
              let styleData = resizedStyle.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process images"])
        }
        
        let base64Hand = handData.base64EncodedString()
        let base64Style = styleData.base64EncodedString()
        
        // Advanced Multimodal Prompt
        let promptText = """
        Role: Expert AI Stylist.
        Task: Perform a "Style Transfer" for nail art.
        
        Inputs:
        1. Target Image: A photo of a hand.
        2. Reference Image: A photo showing a specific nail design (color, pattern, texture).
        
        Directives:
        - Analyze the Reference Image (Input 2) to extract the nail art style (color palette, finish, pattern).
        - Apply this exact style onto the fingernails of the Target Image (Input 1).
        - **Constraint**: Maintain the lighting, skin tone, and hand structure of Input 1 exactly as they are. Only the nail surface should change.
        - Ensure the new design follows the curvature of the nails in Input 1 naturally.
        """
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": promptText],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Hand
                            ]
                        ],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Style
                            ]
                        ]
                    ]
                ]
            ],
            "safetySettings": [
                ["category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"],
                ["category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_ONLY_HIGH"],
                ["category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_ONLY_HIGH"],
                ["category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_ONLY_HIGH"]
            ]
        ]
        
        return try await performRequest(requestBody: requestBody, isPremium: isPremium)
    }

    // MARK: - Internal Network Helper
    
    private func performRequest(requestBody: [String: Any], isPremium: Bool) async throws -> UIImage {
        // 5. URL Request
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(modelName):generateContent?key=\(apiKey)") else {
            throw NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        // 6. Perform Request
        let (data, response) = try await URLSession.shared.data(for: request)

        // 7. Handle HTTP Errors
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorObj = errorJson["error"] as? [String: Any],
               let message = errorObj["message"] as? String {
                print("❌ API Error: \(message)")
                throw NSError(domain: "GeminiAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
            }
            throw NSError(domain: "GeminiAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(httpResponse.statusCode)"])
        }

        // 8. Parse Response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        }

        guard let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first else {
            if let promptFeedback = json["promptFeedback"] as? [String: Any],
               let blockReason = promptFeedback["blockReason"] as? String {
                throw NSError(domain: "SafetyError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Blocked by prompt filter: \(blockReason)"])
            }
            throw NSError(domain: "AIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No candidates returned."])
        }

        // 9. Extract Image
        if let content = firstCandidate["content"] as? [String: Any],
           let parts = content["parts"] as? [[String: Any]] {
            
            for part in parts {
                let inlinePart = (part["inline_data"] as? [String: Any]) ?? (part["inlineData"] as? [String: Any])
                
                if let inlineData = inlinePart,
                   let base64String = inlineData["data"] as? String,
                   let imageData = Data(base64Encoded: base64String),
                   let finalImage = UIImage(data: imageData) {
                    
                    print("✅ Successfully decoded image! (Premium: \(isPremium))")
                    return finalImage
                }
            }
        }

        print("⚠️ Response contained no image data.")
        throw NSError(domain: "AIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Model returned success but no image found."])
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
