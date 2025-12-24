// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @StateObject var dataService = DataService()
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    let categories = ["All", "Minimal", "Glam", "Seasonal", "Bridal", "Trendy"]
    
    var filteredDesigns: [NailDesign] {
        var result = dataService.designs
        
        if selectedCategory != "All" {
            result = result.filter { $0.category.caseInsensitiveCompare(selectedCategory) == .orderedSame }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Search styles...", text: $searchText)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedCategory == category ? Color.pink : Color.gray.opacity(0.1))
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                // Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                        ForEach(filteredDesigns) { design in
                            NavigationLink(destination: NailDetailView(design: design)) {
                                DesignCard(design: design, isFavorite: dataService.isFavorite(design)) {
                                    dataService.toggleFavorite(design: design)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("NailTry")
        }
        .environmentObject(dataService)
    }
}

struct DesignCard: View {
    let design: NailDesign
    let isFavorite: Bool
    let onToggleFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: design.imageUrl)) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else {
                        Color.gray.opacity(0.2)
                            .overlay(Image(systemName: "photo").foregroundColor(.gray))
                    }
                }
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
                
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            Text(design.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(design.category)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
