// Configuration.swift
import Foundation

enum Configuration {
    static var geminiAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path),
              let apiKey = dictionary["GEMINI_API_KEY"] as? String, !apiKey.isEmpty else {
            fatalError("🛑 CRITICAL: Missing Secrets.plist or GEMINI_API_KEY. Please create the file.")
        }
        return apiKey
    }
}
