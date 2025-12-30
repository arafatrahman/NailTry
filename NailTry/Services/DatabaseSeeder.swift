// Services/DatabaseSeeder.swift
import Foundation
import FirebaseFirestore

class DatabaseSeeder {
    static let shared = DatabaseSeeder()
    private let db = Firestore.firestore()
    
    // Base URL for your images
    private let baseUrl = "https://webbird.co.uk/wp-content/nailvisionai/"
    
    // MARK: - Master Upload Function
    func uploadAll() {
        print("🚀 Starting bulk upload...")
        
        // Only uploading the "Milky & Soap" category + Test Design
        uploadMilkySoap()
    }
    
    // MARK: - 1. Milky & Soap Nails (Unified Style DNA)
    // Category: Minimalist Style
    // Strategy: Prompts defined as pure 'Style DNA' (Texture/Material only) for the Gemini Texture Engine.
    // The Manual Prompts are optimized for generating realistic mockups (Thumbnails).
    func uploadMilkySoap() {
        let categoryName = "Milky & Soap"
        print("--- Uploading \(categoryName) ---")
        
        var designs: [NailDesign] = []
        
        // 1. Pure Milk
        let dna1 = "Milky White Gel. Texture: Semi-sheer, creamy white (skimmed milk look). Opacity: 60%. Finish: Ultra-glossy, wet-look 'soap' finish. Style: Minimalist clean girl."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Milky White Gel nails. Texture: Semi-sheer, creamy white (skimmed milk look). Opacity: 60%. Finish: Ultra-glossy, wet-look 'soap' finish. Style: Minimalist clean girl. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Pure Milk",
            category: categoryName,
            imageUrl: "\(baseUrl)PureMilk.jpg",
            prompt: dna1,
            isPremium: false,
            isFeatured: false
        ))
        
        // 2. Soap Pink
        let dna2 = "Soap Pink. Color: Very pale, translucent baby pink. Texture: Jelly-like, wet look. Effect: 'Your nails but better' (MNBB). Finish: High shine glass reflection."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Soap Pink nails. Color: Very pale, translucent baby pink. Texture: Jelly-like, wet look. Effect: 'Your nails but better' (MNBB). Finish: High shine glass reflection. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Soap Pink",
            category: categoryName,
            imageUrl: "\(baseUrl)SoapPink.jpg",
            prompt: dna2,
            isPremium: false,
            isFeatured: false
        ))
        
        // 3. Glazed Donut
        let dna3 = "Glazed Donut / Chrome Pearl. Base: Milky white. Overlay: Fine pearlescent chrome powder. Effect: Soft white glowing shimmer."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Glazed Donut Chrome Pearl nails. Base: Milky white. Overlay: Fine pearlescent chrome powder. Effect: Soft white glowing shimmer. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Glazed Donut",
            category: categoryName,
            imageUrl: "\(baseUrl)GlazedDonut.jpg",
            prompt: dna3,
            isPremium: false,
            isFeatured: false
        ))
        
        // 4. Milky Micro-French
        let dna4 = "Micro French Manicure. Base: Sheer milky nude. Detail: Razor-thin, crisp white line at the very tip. Style: Ultra-minimalist modern french. Finish: Glossy."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Micro French Manicure. Base: Sheer milky nude. Detail: Razor-thin, crisp white line at the very tip. Style: Ultra-minimalist modern french. Finish: Glossy. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Milky Micro-French",
            category: categoryName,
            imageUrl: "\(baseUrl)MilkyMicroFrench.jpg",
            prompt: dna4,
            isPremium: true,
            isFeatured: false
        ))
        
        // 5. Cloud Smoke
        let dna5 = "Milky Marble / Cloud Smoke. Base: Sheer white. Effect: Soft, wispy white smoke diffusion (marble ink effect). Style: Dreamy and ethereal. Finish: Glossy."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Milky Marble Cloud Smoke nails. Base: Sheer white. Effect: Soft, wispy white smoke diffusion (marble ink effect). Style: Dreamy and ethereal. Finish: Glossy. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Cloud Smoke",
            category: categoryName,
            imageUrl: "\(baseUrl)CloudSmoke.jpg",
            prompt: dna5,
            isPremium: false,
            isFeatured: false
        ))
        
        // 6. Lavender Soap
        let dna8 = "Lavender Milk. Color: Extremely pale, sheer lilac purple. Texture: Foggy/Misty semi-transparent. Style: Soft and delicate. Finish: High Gloss."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Lavender Milk nails. Color: Extremely pale, sheer lilac purple. Texture: Foggy/Misty semi-transparent. Style: Soft and delicate. Finish: High Gloss. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Lavender Soap",
            category: categoryName,
            imageUrl: "\(baseUrl)LavenderSoap.jpg",
            prompt: dna8,
            isPremium: false,
            isFeatured: false
        ))
        
        // 7. Floating Gold
        let dna9 = "Milky Gold Flake. Base: Semi-sheer white. Detail: Scattered, delicate gold leaf flakes embedded in the gel. Style: Expensive minimalist. Finish: Glossy."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Milky Gold Flake nails. Base: Semi-sheer white. Detail: Scattered, delicate gold leaf flakes embedded in the gel. Style: Expensive minimalist. Finish: Glossy. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Floating Gold",
            category: categoryName,
            imageUrl: "\(baseUrl)FloatingGold.jpg",
            prompt: dna9,
            isPremium: false,
            isFeatured: false
        ))
        
        // 8. Clean Girl Ombre
        let dna10 = "Baby Boomer / Milky Ombre. Technique: Soft gradient fade. Colors: Natural pink base fading seamlessly into milky white tips. Finish: High Gloss."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Baby Boomer Milky Ombre nails. Technique: Soft gradient fade. Colors: Natural pink base fading seamlessly into milky white tips. Finish: High Gloss. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Clean Girl Ombre",
            category: categoryName,
            imageUrl: "\(baseUrl)CleanGirlOmbre.jpg",
            prompt: dna10,
            isPremium: true,
            isFeatured: true
        ))
        
        // 9. TEST STYLE: Obsidian Vein
        let dnaTest = "Kintsugi-style Black Marble. Base: Matte charcoal black stone texture. Detail: Jagged, liquid gold veins running through the cracks. Finish: Contrast between ultra-matte stone and high-shine metallic gold. Style: Wabi-sabi luxury."
        // MANUAL GENERATION PROMPT: Professional macro photography of a female hand with Kintsugi-style Black Marble nails. Base: Matte charcoal black stone texture. Detail: Jagged, liquid gold veins running through the cracks. Finish: Contrast between ultra-matte stone and high-shine metallic gold. Style: Wabi-sabi luxury. Realistic skin texture, soft studio lighting, clean solid beige background, 8k resolution.
        designs.append(NailDesign(
            id: nil,
            name: "Obsidian Vein",
            category: categoryName,
            imageUrl: "https://placehold.co/1024x1024/black/gold?text=Obsidian",
            prompt: dnaTest,
            isPremium: false,
            isFeatured: true
        ))
        
        upload(designs: designs)
    }

    // MARK: - Helper
    private func upload(designs: [NailDesign]) {
        for design in designs {
            do {
                try db.collection("nail_styles").addDocument(from: design)
                print("✅ Uploaded: \(design.name)")
            } catch {
                print("❌ Error uploading \(design.name): \(error.localizedDescription)")
            }
        }
    }
}
