// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @StateObject var dataService = DataService()
    
    // Group designs by category
    var designsByCategory: [String: [NailDesign]] {
        Dictionary(grouping: dataService.designs, by: { $0.category })
    }
    
    var categories: [String] {
        designsByCategory.keys.sorted()
    }
    
    // Take the first 5 designs for the Header Slider
    var featuredDesigns: [NailDesign] {
        Array(dataService.designs.prefix(5))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // 1. Hero Slider (Carousel)
                    if !featuredDesigns.isEmpty {
                        HeroCarousel(designs: featuredDesigns)
                    }
                    
                    // 2. Dynamic Categories
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
                                        dataService: dataService
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
        }
        .environmentObject(dataService)
    }
}

// MARK: - Components

struct HeroCarousel: View {
    let designs: [NailDesign]
    
    var body: some View {
        TabView {
            ForEach(designs) { design in
                NavigationLink(destination: NailDetailView(design: design)) {
                    ZStack(alignment: .bottomLeading) {
                        // Image
                        AsyncImage(url: URL(string: design.imageUrl)) { phase in
                            if let img = phase.image {
                                img.resizable().scaledToFill()
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: 340) // Reduced Height
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
                            Text(design.name)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                            
                            HStack {
                                Text("Try now")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 24)
                                    .background(
                                        LinearGradient(colors: [Color.pink, Color.purple], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .clipShape(Capsule())
                                    .shadow(color: .purple.opacity(0.4), radius: 8, x: 0, y: 4)
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: 340) // Match inner height
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        }
    }
}

struct CategoryRow: View {
    let title: String
    let designs: [NailDesign]
    @ObservedObject var dataService: DataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            
            // Horizontal List
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(designs) { design in
                        NavigationLink(destination: NailDetailView(design: design)) {
                            DesignCard(
                                design: design,
                                isFavorite: dataService.isFavorite(design),
                                onToggleFavorite: { dataService.toggleFavorite(design: design) }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20) // Correct leading/trailing padding for list
                .padding(.bottom, 10) // Room for shadow
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
            ZStack(alignment: .topTrailing) {
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
                
                // Favorite Button
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .font(.system(size: 14))
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(8)
            }
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Text Info
            VStack(alignment: .leading, spacing: 2) {
                Text(design.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1) // Prevents multi-line expansion
                    .truncationMode(.tail)
                
                Text(design.category)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(width: 150, alignment: .leading) // Aligns text to image width
        }
    }
}
