// Views/HomeView.swift
import SwiftUI

struct HomeView: View {
    @StateObject var dataService = DataService()
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 20) {
                    ForEach(dataService.designs) { design in
                        NavigationLink(destination: NailDetailView(design: design)) {
                            VStack(alignment: .leading) {
                                // Design Card
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
                                
                                Text(design.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") { authService.signOut() }
                        .foregroundColor(.pink)
                }
            }
            .onAppear { dataService.fetchDesigns() }
        }
    }
}
