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
        
        // UNCOMMENT the category you want to upload.
        // Recommended: Upload one batch at a time.
        
        uploadCyberChrome()
        // uploadAura()
        // uploadVelvet()
        // uploadBioGlow()
    }
    
    // MARK: - 1. Cyber Chrome (Futuristic & Liquid Metal)
    // Keywords used: "Chrome", "Metallic", "Liquid", "High Gloss"
    func uploadCyberChrome() {
        let categoryName = "Cyber Chrome"
        print("--- Uploading \(categoryName) ---")
        
        let designs = [
            // 1. Liquid Silver
            // Thumbnail Gen: Extreme macro shot of liquid silver chrome nails, melting metal texture, studio lighting, hyper-realistic reflection --ar 3:4
            NailDesign(
                id: nil, name: "Liquid Silver", category: categoryName,
                imageUrl: "\(baseUrl)LiquidSilver.jpg",
                prompt: "Liquid Silver Chrome. Material: Molten aluminum with mirror-finish. Physics: High-contrast reflections, flowing liquid metal texture. Lighting: Studio cool white specular highlights.",
                isPremium: true, isFeatured: true
            ),
            // 2. Holographic Glitch
            // Thumbnail Gen: Holographic silver nails with rainbow prism reflections, digital glitch distortion effect, cyberpunk style --ar 3:4
            NailDesign(
                id: nil, name: "Holographic Glitch", category: categoryName,
                imageUrl: "\(baseUrl)HolographicGlitch.jpg",
                prompt: "Holographic Metallic Chrome. Material: Prismatic rainbow silver. Effect: Digital glitch distortion pattern. Physics: Iridescent light refraction, sharp metallic edges.",
                isPremium: false, isFeatured: false
            ),
            // 3. Rose Gold Circuit
            // Thumbnail Gen: Rose gold chrome nails with etched circuit board lines, expensive tech jewelry aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Rose Gold Circuit", category: categoryName,
                imageUrl: "\(baseUrl)RoseGoldCircuit.jpg",
                prompt: "Rose Gold Metallic. Texture: Mirror-polished copper with etched electronic circuit board lines. Finish: High gloss luxury metal.",
                isPremium: true, isFeatured: false
            ),
            // 4. Molten Lead
            // Thumbnail Gen: Dark gunmetal grey chrome nails, heavy industrial liquid metal texture, dripping tips --ar 3:4
            NailDesign(
                id: nil, name: "Molten Lead", category: categoryName,
                imageUrl: "\(baseUrl)MoltenLead.jpg",
                prompt: "Gunmetal Grey Chrome. Material: Heavy molten lead. Texture: Thick, viscous liquid metal with dark industrial reflections. Finish: High gloss.",
                isPremium: false, isFeatured: false
            ),
            // 5. Neon Chrome
            // Thumbnail Gen: Mirror chrome nails reflecting pink and blue neon city lights, wet surface, cyberpunk night --ar 3:4
            NailDesign(
                id: nil, name: "Neon Chrome", category: categoryName,
                imageUrl: "\(baseUrl)NeonChrome.jpg",
                prompt: "Mirror Chrome. Environment: Reflecting vibrant neon pink and blue city lights (Cyberpunk night). Finish: Wet, ultra-glossy glass surface.",
                isPremium: true, isFeatured: true
            ),
            // 6. Cyber Punk Purple
            // Thumbnail Gen: Metallic purple chrome with sharp angular geometry, sci-fi royal aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Cyber Punk Purple", category: categoryName,
                imageUrl: "\(baseUrl)CyberPunkPurple.jpg",
                prompt: "Electric Purple Metallic. Style: Hard-surface sci-fi plating. Finish: Anodized aluminum with sharp, angular light reflections.",
                isPremium: false, isFeatured: false
            ),
            // 7. Android Skin
            // Thumbnail Gen: Pearl white chrome, synthetic android skin texture, clean minimalist futuristic --ar 3:4
            NailDesign(
                id: nil, name: "Android Skin", category: categoryName,
                imageUrl: "\(baseUrl)AndroidSkin.jpg",
                prompt: "Pearlescent White Chrome. Material: Synthetic android skin. Texture: Smooth, clean, futuristic ceramic-metal hybrid. Finish: Soft satin glow.",
                isPremium: true, isFeatured: false
            ),
            // 8. Galactic Mirror
            // Thumbnail Gen: Obsidian black chrome nails reflecting stars and galaxies, deep space aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Galactic Mirror", category: categoryName,
                imageUrl: "\(baseUrl)GalacticMirror.jpg",
                prompt: "Obsidian Black Chrome. Reflection: Deep space stars and nebula. Finish: Perfect black mirror, zero texture, infinite depth.",
                isPremium: true, isFeatured: true
            ),
            // 9. Titanium White
            // Thumbnail Gen: Brushed titanium metal nails, matte silver surface with shiny edges, aerospace engineering look --ar 3:4
            NailDesign(
                id: nil, name: "Titanium White", category: categoryName,
                imageUrl: "\(baseUrl)TitaniumWhite.jpg",
                prompt: "Brushed Titanium Metallic. Texture: Fine horizontal brushed metal scratches. Finish: Semi-matte industrial silver with polished edges.",
                isPremium: false, isFeatured: false
            ),
            // 10. Copper Oxide
            // Thumbnail Gen: Shiny copper nails with green rust oxidation at the tips, weathered steampunk metal --ar 3:4
            NailDesign(
                id: nil, name: "Copper Oxide", category: categoryName,
                imageUrl: "\(baseUrl)CopperOxide.jpg",
                prompt: "Aged Copper Chrome. Detail: Shiny penny copper base transitioning to Green Verdigris (oxidation) at the tips. Style: Weathered steampunk metal.",
                isPremium: true, isFeatured: false
            )
        ]
        
        upload(designs: designs)
    }
    
    // MARK: - 2. Aura & Energy (Soft Gradients & Glow)
    // Keywords used: "Airbrushed", "Gradient", "Soft Focus", "Glossy"
    func uploadAura() {
        let categoryName = "Aura"
        print("--- Uploading \(categoryName) ---")
        
        let designs = [
            // 1. Angel Aura
            // Thumbnail Gen: Soft pink and white gradient aura nails, glowing center, dreamy spiritual aesthetic, glossy finish --ar 3:4
            NailDesign(
                id: nil, name: "Angel Aura", category: categoryName,
                imageUrl: "\(baseUrl)AngelAura.jpg",
                prompt: "Angel Aura style. Colors: Soft baby pink fading into a glowing white center. Technique: Airbrushed gradient. Finish: Ultra-Glossy Gel.",
                isPremium: false, isFeatured: true
            ),
            // 2. Neon Soul
            // Thumbnail Gen: Matte black nails with a neon green glowing aura center, radioactive hazard look --ar 3:4
            NailDesign(
                id: nil, name: "Neon Soul", category: categoryName,
                imageUrl: "\(baseUrl)NeonSoul.jpg",
                prompt: "Neon Aura style. Base: Solid Matte Black. Center: Glowing radioactive green diffused orb. Finish: Matte base with luminous center.",
                isPremium: true, isFeatured: false
            ),
            // 3. Sunset Vibe
            // Thumbnail Gen: Orange and purple sunset gradient nails, warm glow, summer evening aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Sunset Vibe", category: categoryName,
                imageUrl: "\(baseUrl)SunsetVibe.jpg",
                prompt: "Sunset Gradient Aura. Colors: Deep violet edges fading to bright tangerine orange center. Finish: High Gloss glass skin look.",
                isPremium: false, isFeatured: false
            ),
            // 4. Heart Chakra
            // Thumbnail Gen: Rose quartz pink aura nails with magenta center, crystal healing energy aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Heart Chakra", category: categoryName,
                imageUrl: "\(baseUrl)HeartChakra.jpg",
                prompt: "Crystal Aura. Colors: Rose quartz pink with deep magenta center. Texture: Semitransparent jelly look. Finish: Glossy.",
                isPremium: false, isFeatured: true
            ),
            // 5. Midnight Aura
            // Thumbnail Gen: Navy blue nails with light blue moon glow center, mystical night sky --ar 3:4
            NailDesign(
                id: nil, name: "Midnight Aura", category: categoryName,
                imageUrl: "\(baseUrl)MidnightAura.jpg",
                prompt: "Midnight Aura. Colors: Dark Navy Blue edges, glowing Moonlight Blue center. Mood: Mystical, foggy night. Finish: Glossy.",
                isPremium: true, isFeatured: false
            ),
            // 6. Lavender Haze
            // Thumbnail Gen: Pale purple nails with white misty center, dreamy cloud aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Lavender Haze", category: categoryName,
                imageUrl: "\(baseUrl)LavenderHaze.jpg",
                prompt: "Lavender Haze. Colors: Pale lilac purple with misty white center. Texture: Soft cloud diffusion. Finish: Satin.",
                isPremium: false, isFeatured: false
            ),
            // 7. Peachy Glow
            // Thumbnail Gen: Peach colored nails with bright orange glowing center, fresh fruit aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Peachy Glow", category: categoryName,
                imageUrl: "\(baseUrl)PeachyGlow.jpg",
                prompt: "Peach Fuzz Aura. Colors: Soft peach edges, vibrant neon orange center. Style: Juicy, fresh summer fruit. Finish: Super Glossy.",
                isPremium: false, isFeatured: false
            ),
            // 8. Electric Blue Halo
            // Thumbnail Gen: Electric blue nails with white halo ring center, energy field effect --ar 3:4
            NailDesign(
                id: nil, name: "Electric Blue Halo", category: categoryName,
                imageUrl: "\(baseUrl)ElectricBlueHalo.jpg",
                prompt: "Electric Aura. Colors: Vibrant Cobalt Blue with stark bright white center orb. Effect: Glowing energy field. Finish: Glossy.",
                isPremium: true, isFeatured: true
            ),
            // 9. Mystic Green
            // Thumbnail Gen: Forest green nails with lime green glowing center, swamp witch aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Mystic Green", category: categoryName,
                imageUrl: "\(baseUrl)MysticGreen.jpg",
                prompt: "Swamp Witch Aura. Colors: Deep Forest Green edges, toxic Lime Green center. Style: Dark nature magic. Finish: Glossy.",
                isPremium: true, isFeatured: false
            ),
            // 10. Solar Flare
            // Thumbnail Gen: Deep red nails with bright yellow burning center, fire heat gradient --ar 3:4
            NailDesign(
                id: nil, name: "Solar Flare", category: categoryName,
                imageUrl: "\(baseUrl)SolarFlare.jpg",
                prompt: "Solar Flare Aura. Colors: Blood Red edges, Blinding Yellow/White center. Effect: Burning heat gradient. Finish: High Gloss.",
                isPremium: true, isFeatured: false
            )
        ]
        
        upload(designs: designs)
    }
    
    // MARK: - 3. Velvet & Cat Eye (Magnetic Textures)
    // Keywords used: "Velvet", "Cat Eye", "Magnetic", "Shimmer"
    func uploadVelvet() {
        let categoryName = "Velvet"
        print("--- Uploading \(categoryName) ---")
        
        let designs = [
            // 1. Midnight Velvet
            // Thumbnail Gen: Deep blue velvet nails, magnetic shimmer texture, crushed gemstone look, luxury --ar 3:4
            NailDesign(
                id: nil, name: "Midnight Velvet", category: categoryName,
                imageUrl: "\(baseUrl)MidnightVelvet.jpg",
                prompt: "Midnight Blue Velvet. Material: Magnetic Cat Eye Polish. Physics: Deep shimmering 3D depth, crushed sapphire gemstone texture. Light: Soft shifting reflections.",
                isPremium: true, isFeatured: true
            ),
            // 2. Silk Champagne
            // Thumbnail Gen: Gold velvet nails, silk fabric texture, magnetic effect, elegant wedding style --ar 3:4
            NailDesign(
                id: nil, name: "Silk Champagne", category: categoryName,
                imageUrl: "\(baseUrl)SilkChampagne.jpg",
                prompt: "Champagne Gold Velvet. Texture: Soft woven silk fabric simulation using magnetic polish. Finish: Expensive, elegant shimmer.",
                isPremium: false, isFeatured: false
            ),
            // 3. Emerald Cat Eye
            // Thumbnail Gen: Emerald green cat eye nails, sharp diagonal magnetic line, jewel tone --ar 3:4
            NailDesign(
                id: nil, name: "Emerald Cat Eye", category: categoryName,
                imageUrl: "\(baseUrl)EmeraldCatEye.jpg",
                prompt: "Emerald Green Cat Eye. Technique: Single sharp diagonal magnetic line reflecting light. Base: Deep black-green. Highlight: Bright vivid emerald.",
                isPremium: true, isFeatured: true
            ),
            // 4. Ruby Dust
            // Thumbnail Gen: Red velvet nails, crushed ruby dust texture, sparkling depth, romantic --ar 3:4
            NailDesign(
                id: nil, name: "Ruby Dust", category: categoryName,
                imageUrl: "\(baseUrl)RubyDust.jpg",
                prompt: "Ruby Red Velvet. Texture: Fine crushed diamond dust in deep red gel. Physics: Multi-faceted micro-sparkles. Style: Romantic luxury.",
                isPremium: true, isFeatured: false
            ),
            // 5. Amethyst Magnetic
            // Thumbnail Gen: Purple magnetic nails, galaxy swirl effect, crystal texture --ar 3:4
            NailDesign(
                id: nil, name: "Amethyst Magnetic", category: categoryName,
                imageUrl: "\(baseUrl)AmethystMagnetic.jpg",
                prompt: "Amethyst Purple Magnetic. Effect: Swirling galaxy pattern created with magnet. Texture: Deep quartz crystal depth. Finish: Glossy.",
                isPremium: false, isFeatured: false
            ),
            // 6. Obsidian Sand
            // Thumbnail Gen: Black velvet nails with silver glitter, starry night black sand look --ar 3:4
            NailDesign(
                id: nil, name: "Obsidian Sand", category: categoryName,
                imageUrl: "\(baseUrl)ObsidianSand.jpg",
                prompt: "Black Velvet. Texture: Black sand with silver magnetic sparkles. Effect: Starry night sky. Finish: Matte with sparkling points.",
                isPremium: true, isFeatured: false
            ),
            // 7. Platinum Velour
            // Thumbnail Gen: Silver platinum nails, soft fuzzy velour texture, high fashion magnetic look --ar 3:4
            NailDesign(
                id: nil, name: "Platinum Velour", category: categoryName,
                imageUrl: "\(baseUrl)PlatinumVelour.jpg",
                prompt: "Platinum Silver Velvet. Texture: Visual softness like velour fabric but made of metallic shimmer. Color: Cool white-silver.",
                isPremium: true, isFeatured: true
            ),
            // 8. Bronze Shimmer
            // Thumbnail Gen: Bronze velvet nails, warm autumn tones, metallic brown shimmer --ar 3:4
            NailDesign(
                id: nil, name: "Bronze Shimmer", category: categoryName,
                imageUrl: "\(baseUrl)BronzeShimmer.jpg",
                prompt: "Bronze Velvet. Colors: Warm autumn brown and gold. Texture: Metallic magnetic shimmer with deep shadow contrast.",
                isPremium: false, isFeatured: false
            ),
            // 9. Sapphire Deep
            // Thumbnail Gen: Dark sapphire blue nails with bright blue magnetic flare, ocean depth --ar 3:4
            NailDesign(
                id: nil, name: "Sapphire Deep", category: categoryName,
                imageUrl: "\(baseUrl)SapphireDeep.jpg",
                prompt: "Deep Sapphire Cat Eye. Base: Almost black blue. Effect: Bright electric blue magnetic flare floating over the surface. Depth: Oceanic.",
                isPremium: true, isFeatured: false
            ),
            // 10. Galaxy Velvet
            // Thumbnail Gen: Multichrome magnetic nails shifting purple to green, nebula effect, velvet finish --ar 3:4
            NailDesign(
                id: nil, name: "Galaxy Velvet", category: categoryName,
                imageUrl: "\(baseUrl)GalaxyVelvet.jpg",
                prompt: "Multichrome Galaxy Velvet. Colors: Color-shifting pigments (Purple to Green to Gold). Texture: Magnetic nebula clouds. Finish: High Gloss.",
                isPremium: true, isFeatured: true
            )
        ]
        
        upload(designs: designs)
    }
    
    // MARK: - 4. Bio-Glow (Bioluminescence & Neon)
    // Keywords used: "Bioluminescent", "Neon", "Glow", "Organic"
    func uploadBioGlow() {
        let categoryName = "Bio-Glow"
        print("--- Uploading \(categoryName) ---")
        
        let designs = [
            // 1. Avatar Glow
            // Thumbnail Gen: Blue bioluminescent dots on dark nails, avatar nature texture, glowing veins --ar 3:4
            NailDesign(
                id: nil, name: "Avatar Glow", category: categoryName,
                imageUrl: "\(baseUrl)AvatarGlow.jpg",
                prompt: "Bioluminescent Avatar. Base: Dark Indigo. Pattern: Glowing cyan blue organic dots and veins. Style: Pandora nature texture. Finish: Glossy.",
                isPremium: true, isFeatured: true
            ),
            // 2. Jellyfish Sting
            // Thumbnail Gen: Translucent pink nails with electric blue glowing tendrils, jellyfish aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Jellyfish Sting", category: categoryName,
                imageUrl: "\(baseUrl)JellyfishSting.jpg",
                prompt: "Jellyfish Bioluminescence. Base: Translucent sheer pink. Pattern: Electric blue glowing tendrils/tentacles. Finish: Wet Jelly look.",
                isPremium: false, isFeatured: false
            ),
            // 3. Toxic Green
            // Thumbnail Gen: Black nails with oozing glowing green slime, radioactive hazard aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Toxic Green", category: categoryName,
                imageUrl: "\(baseUrl)ToxicGreen.jpg",
                prompt: "Toxic Slime Glow. Base: Black. Pattern: Dripping radioactive neon green slime. Effect: Self-illuminating. Finish: Glossy.",
                isPremium: true, isFeatured: false
            ),
            // 4. Deep Sea Lure
            // Thumbnail Gen: Pitch black nails with single bright light orb at tip, angler fish aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Deep Sea Lure", category: categoryName,
                imageUrl: "\(baseUrl)DeepSeaLure.jpg",
                prompt: "Angler Fish Lure. Base: Pitch Black (Abyss). Detail: Single bright glowing white/yellow orb at the nail tip. Atmosphere: Deep sea darkness.",
                isPremium: true, isFeatured: true
            ),
            // 5. Firefly Night
            // Thumbnail Gen: Dark blue nails with tiny yellow glowing firefly dots, summer night aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Firefly Night", category: categoryName,
                imageUrl: "\(baseUrl)FireflyNight.jpg",
                prompt: "Firefly Garden. Base: Midnight Blue. Pattern: Scattered tiny glowing yellow-green dots with soft halos. Mood: Magical summer night.",
                isPremium: false, isFeatured: false
            ),
            // 6. Radioactive Pink
            // Thumbnail Gen: Hot pink nails emitting light, fuzzy glowing edges, neon sign look --ar 3:4
            NailDesign(
                id: nil, name: "Radioactive Pink", category: categoryName,
                imageUrl: "\(baseUrl)RadioactivePink.jpg",
                prompt: "Radioactive Neon Pink. Effect: Entire nail surface emitting bright pink light. Edges: Fuzzy, glowing neon sign effect. Finish: Matte.",
                isPremium: false, isFeatured: false
            ),
            // 7. Alien Skin
            // Thumbnail Gen: Iridescent green scaly texture glowing in dark, reptilian alien skin --ar 3:4
            NailDesign(
                id: nil, name: "Alien Skin", category: categoryName,
                imageUrl: "\(baseUrl)AlienSkin.jpg",
                prompt: "Alien Reptile Skin. Texture: Iridescent green scales. Effect: Bioluminescent glow coming from between the scales. Style: Sci-Fi biological.",
                isPremium: true, isFeatured: true
            ),
            // 8. Fungus Glow
            // Thumbnail Gen: Brown nails with glowing purple mushroom gills, magical forest fungi --ar 3:4
            NailDesign(
                id: nil, name: "Fungus Glow", category: categoryName,
                imageUrl: "\(baseUrl)FungusGlow.jpg",
                prompt: "Magic Mushrooms. Base: Earthy brown. Pattern: Glowing purple mushroom gills/lines. Style: Forest floor bioluminescence.",
                isPremium: false, isFeatured: false
            ),
            // 9. Electric Coral
            // Thumbnail Gen: Coral texture nails with glowing orange tips, underwater reef aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Electric Coral", category: categoryName,
                imageUrl: "\(baseUrl)ElectricCoral.jpg",
                prompt: "Electric Coral Reef. Texture: Rough organic coral structure. Color: Living Coral with glowing neon orange tips. Finish: Matte stone-like.",
                isPremium: false, isFeatured: false
            ),
            // 10. Cyber Nature
            // Thumbnail Gen: Green leaf patterns with glowing circuit board veins, solarpunk aesthetic --ar 3:4
            NailDesign(
                id: nil, name: "Cyber Nature", category: categoryName,
                imageUrl: "\(baseUrl)CyberNature.jpg",
                prompt: "Cyber Nature (Solarpunk). Base: Organic green leaf texture. Veins: Glowing white electronic circuit lines running through the leaf.",
                isPremium: true, isFeatured: true
            )
        ]
        
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
