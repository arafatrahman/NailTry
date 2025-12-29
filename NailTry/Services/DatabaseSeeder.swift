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
        
        // Only uploading the "Milky & Soap" category.
        uploadMilkySoap()
        
        // uploadCyberChrome()
        // uploadAura()
        // uploadVelvet()
        // uploadBioGlow()
    }
    
    // MARK: - 1. Milky & Soap Nails (Minimalist & Clean)
    // Category: Minimalist Style
    // Focus: Clean backgrounds, distinct textures, Ratio 3:4.
    func uploadMilkySoap() {
        let categoryName = "Milky & Soap"
        print("--- Uploading \(categoryName) ---")
        
        let designs = [
            // 1. Pure Milk (The Classic)
            // Thumbnail Gen: Macro shot of milky white nails, clean solid beige background, soft studio lighting. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Pure Milk", category: categoryName,
                imageUrl: "\(baseUrl)PureMilk.jpg",
                prompt: "Milky White Gel. Texture: Semi-sheer, creamy white (skimmed milk look). Opacity: 60%. Finish: Ultra-glossy, wet-look 'soap' finish. Style: Minimalist clean girl.",
                isPremium: false, isFeatured: false
            ),
            
            // 2. Soap Pink (The Natural)
            // Thumbnail Gen: Translucent sheer pink nails, wet look, solid pastel background, no props. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Soap Pink", category: categoryName,
                imageUrl: "\(baseUrl)SoapPink.jpg",
                prompt: "Soap Pink. Color: Very pale, translucent baby pink. Texture: Jelly-like, wet look. Effect: 'Your nails but better' (MNBB). Finish: High shine glass reflection.",
                 isPremium: false, isFeatured: false
            ),
            
            // 3. Glazed Donut (The Chrome)
            // Thumbnail Gen: Milky white nails with pearl powder shimmer, clean white background, soft highlights. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Glazed Donut", category: categoryName,
                imageUrl: "\(baseUrl)GlazedDonut.jpg",
                prompt: "Glazed Donut / Chrome Pearl. Base: Milky white. Overlay: Fine pearlescent chrome powder. Effect: Soft white glowing shimmer. Lighting: Softbox highlights.",
               isPremium: false, isFeatured: false
            ),
            
            // 4. Milky Micro-French (The Art)
            // Thumbnail Gen: Milky nude nails with razor thin white french tip, solid background. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Milky Micro-French", category: categoryName,
                imageUrl: "\(baseUrl)MilkyMicroFrench.jpg",
                prompt: "Micro French Manicure. Base: Sheer milky nude. Detail: Razor-thin, crisp white line at the very tip. Style: Ultra-minimalist modern french. Finish: Glossy.",
                isPremium: true, isFeatured: false
            ),
            
            // 5. Cloud Smoke (The Texture)
            // Thumbnail Gen: White nails with soft wispy smoke marble effect, clean background. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Cloud Smoke", category: categoryName,
                imageUrl: "\(baseUrl)CloudSmoke.jpg",
                prompt: "Milky Marble / Cloud Smoke. Base: Sheer white. Effect: Soft, wispy white smoke diffusion (marble ink effect). Style: Dreamy and ethereal. Finish: Glossy.",
                isPremium: false, isFeatured: false
            ),
            

           
            
            // 8. Lavender Soap (The Pastel)
            // Thumbnail Gen: Sheer lilac purple nails, misty look, solid white background. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Lavender Soap", category: categoryName,
                imageUrl: "\(baseUrl)LavenderSoap.jpg",
                prompt: "Lavender Milk. Color: Extremely pale, sheer lilac purple. Texture: Foggy/Misty semi-transparent. Style: Soft and delicate. Finish: High Gloss.",
                isPremium: false, isFeatured: false
            ),
            
            // 9. Floating Gold (The Luxury)
            // Thumbnail Gen: Milky nails with delicate gold leaf flakes, luxury minimalist, solid background. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Floating Gold", category: categoryName,
                imageUrl: "\(baseUrl)FloatingGold.jpg",
                prompt: "Milky Gold Flake. Base: Semi-sheer white. Detail: Scattered, delicate gold leaf flakes embedded in the gel. Style: Expensive minimalist. Finish: Glossy.",
                 isPremium: false, isFeatured: false
            ),
            
            // 10. Clean Girl Ombre (The Gradient)
            // Thumbnail Gen: Nude to white gradient nails (boomer), smooth fade, solid background. Ratio 3:4. Output: JPG < 80kb.
            NailDesign(
                id: nil, name: "Clean Girl Ombre", category: categoryName,
                imageUrl: "\(baseUrl)CleanGirlOmbre.jpg",
                prompt: "Baby Boomer / Milky Ombre. Technique: Soft gradient fade. Colors: Natural pink base fading seamlessly into milky white tips. Finish: High Gloss.",
                isPremium: true, isFeatured: true
            )
        ]
        
        upload(designs: designs)
    }
    
    // MARK: - Previous Categories (Preserved but not active)
    
    func uploadCyberChrome() {
        // ... (Code hidden to keep file clean)
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
