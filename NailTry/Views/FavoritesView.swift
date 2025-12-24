// Views/FavoritesView.swift
import SwiftUI

struct FavoritesView: View {
    @StateObject var dataService = DataService()
    
    var favorites: [NailDesign] {
        dataService.designs.filter { dataService.isFavorite($0) }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if favorites.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No favorites yet")
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                            ForEach(favorites) { design in
                                NavigationLink(destination: NailDetailView(design: design)) {
                                    DesignCard(design: design, isFavorite: true) {
                                        dataService.toggleFavorite(design: design)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
        }
        .onAppear {
            dataService.fetchFavorites()
            dataService.fetchDesigns()
        }
    }
}
