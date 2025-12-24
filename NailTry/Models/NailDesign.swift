// Models/NailDesign.swift
import Foundation
import FirebaseFirestore

struct NailDesign: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let name: String
    let category: String
    let imageUrl: String
    let prompt: String
    let isPremium: Bool
    
    // Testing data for when Firebase is empty
    static let samples = [
        NailDesign(id: "1", name: "Classic Red", category: "Classic", imageUrl: "https://placehold.co/400x400/png", prompt: "glossy red nail polish", isPremium: false),
        NailDesign(id: "2", name: "Gold Glitter", category: "Glam", imageUrl: "https://placehold.co/400x400/png", prompt: "gold glitter ombre nail polish", isPremium: true)
    ]
}
