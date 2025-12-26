// Views/HomeView.swift
import SwiftUI
import Combine // Imported for Timer

struct HomeView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var dataService = DataService()
    
    // Controls the "Go Premium" popup
    @State private var showPremiumSheet = false
    
    // Group designs by category
    var designsByCategory: [String: [NailDesign]] {
        Dictionary(grouping: dataService.designs, by: { $0.category })
    }
    
    var categories: [String] {
        designsByCategory.keys.sorted()
    }
    
    // UPDATED: Filter logic to show only designs where isFeatured == true
    var featuredDesigns: [NailDesign] {
        dataService.designs.filter { $0.isFeatured ?? false }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // 1. Hero Slider (Carousel)
                    if !featuredDesigns.isEmpty {
                        HeroCarousel(designs: featuredDesigns, onRequestPremium: {
                            showPremiumSheet = true
                        })
                    }
                    
                    // 2. Custom Design Banner (NEW)
                    // Allows user to upload a style reference & try it on
                    NavigationLink(destination: CustomDesignView()) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Design Your Own")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Upload a style reference & try it on")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                            Image(systemName: "paintpalette.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(
                            LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .shadow(color: .pink.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    // 3. Dynamic Categories
                    VStack(spacing: 25) {
                        if dataService.designs.isEmpty {
                            ProgressView()
                                .padding(.top, 50)
                        } else {
                            ForEach(categories, id: \.self) { category in
                                if let items = designsByCategory[category] {
                                    CategoryRow(
                                        title: category,
                                        designs: items,
                                        dataService: dataService,
                                        onRequestPremium: {
                                            showPremiumSheet = true
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 80) // Extra padding for tab bar
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .sheet(isPresented: $showPremiumSheet) {
                // This reuses the PremiumView defined in ProfileView.swift
                PremiumView()
            }
        }
        .environmentObject(dataService)
    }
}

// MARK: - Components

struct HeroCarousel: View {
    let designs: [NailDesign]
    var onRequestPremium: () -> Void
    @EnvironmentObject var authService: AuthService
    
    // UPDATED: State for auto-sliding
    @State private var currentIndex = 0
    // UPDATED: Timer publisher for 2-second intervals
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            // Enumerated allows us to tag each view with its index for the binding
            ForEach(Array(designs.enumerated()), id: \.element) { index, design in
                Group {
                    // Logic: Block navigation if Premium needed & User is Free
                    if design.isPremium && !authService.isPremium {
                        Button(action: onRequestPremium) {
                            HeroCardContent(design: design)
                        }
                    } else {
                        NavigationLink(destination: NailDetailView(design: design)) {
                            HeroCardContent(design: design)
                        }
                    }
                }
                .tag(index) // Important for TabView selection to work
            }
        }
        .frame(height: 340)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        }
        // UPDATED: Receive timer events to change the index
        .onReceive(timer) { _ in
            withAnimation {
                // Determine next index, loop back to 0 if at the end
                currentIndex = (currentIndex + 1) % designs.count
            }
        }
    }
}

// Extracted for reuse in both Button and NavLink
struct HeroCardContent: View {
    let design: NailDesign
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Image
            AsyncImage(url: URL(string: design.imageUrl)) { phase in
                if let img = phase.image {
                    img.resizable().scaledToFill()
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 340)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            )
            
            // Text & Button Overlay
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(design.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    if design.isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                }
                
                HStack {
                    Text(design.isPremium ? "Unlock Premium" : "Try now")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(
                                colors: design.isPremium ? [Color.yellow, Color.orange] : [Color.pink, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: (design.isPremium ? Color.orange : Color.purple).opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

struct CategoryRow: View {
    let title: String
    let designs: [NailDesign]
    @ObservedObject var dataService: DataService
    var onRequestPremium: () -> Void
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                
                Spacer()
                
                // UPDATED: Gradient "See All" Button
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        LinearGradient(
                            colors: [.pink, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: .pink.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 20)
            
            // Horizontal List
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(designs) { design in
                        // Logic: Block if Premium needed & User is Free
                        if design.isPremium && !authService.isPremium {
                            Button(action: onRequestPremium) {
                                DesignCard(
                                    design: design,
                                    isFavorite: dataService.isFavorite(design),
                                    onToggleFavorite: { dataService.toggleFavorite(design: design) }
                                )
                            }
                        } else {
                            NavigationLink(destination: NailDetailView(design: design)) {
                                DesignCard(
                                    design: design,
                                    isFavorite: dataService.isFavorite(design),
                                    onToggleFavorite: { dataService.toggleFavorite(design: design) }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
    }
}

struct DesignCard: View {
    let design: NailDesign
    let isFavorite: Bool
    let onToggleFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image Area
            ZStack(alignment: .top) {
                AsyncImage(url: URL(string: design.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Color.gray.opacity(0.1)
                            .overlay(ProgressView())
                    }
                }
                .frame(width: 150, height: 180)
                .cornerRadius(16)
                .clipped()
                
                // Overlay Row (Premium Left, Favorite Right)
                HStack {
                    if design.isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    } else {
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Favorite Button (Always works)
                    Button(action: onToggleFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .white)
                            .font(.system(size: 14))
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(8)
            }
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Text Info
            VStack(alignment: .leading, spacing: 2) {
                Text(design.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(design.category)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(width: 150, alignment: .leading)
        }
    }
}
