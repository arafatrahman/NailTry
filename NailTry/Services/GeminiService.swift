// Services/GeminiService.swift
import Foundation
import UIKit

class GeminiService {
    private let apiKey = Configuration.geminiAPIKey
    // Using the stable, production model
    private let modelName = "gemini-2.5-flash-image"

    init() {}

    func generateNailPreview(originalImage: UIImage, designPrompt: String) async throws -> UIImage {
        // 1. Resize & Compress
        // Resize to 1024 to respect model limits and improve speed
        guard let resizedImage = originalImage.resized(to: 1024),
              let jpegData = resizedImage.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image"])
        }
        
        let base64Image = jpegData.base64EncodedString()

        // 2. Prompt
        let promptText = """
        Technical demonstration: Apply a virtual nail polish design.
        Input: A photo of a hand.
        Task: Change the nail polish to: \(designPrompt).
        Requirements: Keep the image photorealistic. Preserve the original hand structure.
        """
        
        // 3. Request Body
        // We set safety settings to BLOCK_ONLY_HIGH to allow hand editing without false positives.
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

        // 4. URL Request
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(modelName):generateContent?key=\(apiKey)") else {
            throw NSError(domain: "NetworkError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        // 5. Perform Request
        let (data, response) = try await URLSession.shared.data(for: request)

        // 6. Handle HTTP Errors
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errorObj = errorJson["error"] as? [String: Any],
               let message = errorObj["message"] as? String {
                print("❌ API Error: \(message)")
                throw NSError(domain: "GeminiAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
            }
            throw NSError(domain: "GeminiAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(httpResponse.statusCode)"])
        }

        // 7. Parse Response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        }

        guard let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first else {
            // Check for Block Reason
            if let promptFeedback = json["promptFeedback"] as? [String: Any],
               let blockReason = promptFeedback["blockReason"] as? String {
                throw NSError(domain: "SafetyError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Blocked by prompt filter: \(blockReason)"])
            }
            throw NSError(domain: "AIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No candidates returned."])
        }

        // 8. Extract Image (Robust Parsing)
        if let content = firstCandidate["content"] as? [String: Any],
           let parts = content["parts"] as? [[String: Any]] {
            
            for part in parts {
                // FIX: Check BOTH "inline_data" (standard) AND "inlineData" (camelCase)
                let inlinePart = (part["inline_data"] as? [String: Any]) ?? (part["inlineData"] as? [String: Any])
                
                if let inlineData = inlinePart,
                   let base64String = inlineData["data"] as? String,
                   let imageData = Data(base64Encoded: base64String),
                   let finalImage = UIImage(data: imageData) {
                    
                    print("✅ Successfully decoded image!")
                    return finalImage
                }
            }
        }

        // If we get here, log the full response to help debug further
        print("⚠️ Response contained no image data. Full JSON: \(String(data: data, encoding: .utf8) ?? "nil")")
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
