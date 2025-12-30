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
    let isFeatured: Bool?
    
    // MARK: - Sample Data for Testing/Preview
    static let samples = [
        NailDesign(
            id: "1",
            name: "Pure Milk",
            category: "Milky & Soap",
            imageUrl: "https://placehold.co/400x400/png",
            prompt: "Milky White Gel. Texture: Semi-sheer, creamy white.",
            isPremium: false,
            isFeatured: true
        ),
        NailDesign(
            id: "2",
            name: "Soap Pink",
            category: "Milky & Soap",
            imageUrl: "https://placehold.co/400x400/png",
            prompt: "Soap Pink. Color: Very pale, translucent baby pink.",
            isPremium: false,
            isFeatured: true
        ),
        NailDesign(
            id: "3",
            name: "Gold Glitter",
            category: "Glam",
            imageUrl: "https://placehold.co/400x400/png",
            prompt: "gold glitter ombre nail polish",
            isPremium: true,
            isFeatured: false
        )
    ]
}
