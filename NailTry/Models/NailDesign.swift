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
    // New field: Optional to ensure backward compatibility with existing data
    let isFeatured: Bool?
    
    // Testing data for when Firebase is empty
    static let samples = [
        NailDesign(
            id: "1",
            name: "Classic Red",
            category: "Classic",
            imageUrl: "https://placehold.co/400x400/png",
            prompt: "glossy red nail polish",
            isPremium: false,
            isFeatured: true
        ),
        NailDesign(
            id: "2",
            name: "Gold Glitter",
            category: "Glam",
            imageUrl: "https://placehold.co/400x400/png",
            prompt: "gold glitter ombre nail polish",
            isPremium: true,
            isFeatured: true
        ),
        NailDesign(
            id: "3",
            name: "Matte Black",
            category: "Classic",
            imageUrl: "https://placehold.co/400x400/png",
            prompt: "matte black nail polish",
            isPremium: false,
            isFeatured: false
        )
    ]
}
