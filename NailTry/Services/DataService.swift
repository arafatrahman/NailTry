// Services/DataService.swift
import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class DataService: ObservableObject {
    @Published var designs: [NailDesign] = []
    @Published var favoriteIds: Set<String> = []
    
    private let db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }
    
    init() {
        fetchDesigns()
        fetchFavorites()
    }
    
    func fetchDesigns() {
        db.collection("nail_styles").getDocuments { [weak self] snapshot, error in
            if let docs = snapshot?.documents, !docs.isEmpty {
                self?.designs = docs.compactMap { try? $0.data(as: NailDesign.self) }
            } else {
                self?.loadSamples()
            }
        }
    }
    
    func fetchFavorites() {
        guard let uid = userId else { return }
        db.collection("users").document(uid).collection("favorites").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self, let docs = snapshot?.documents else { return }
            self.favoriteIds = Set(docs.map { $0.documentID })
        }
    }
    
    func toggleFavorite(design: NailDesign) {
        guard let uid = userId, let designId = design.id else { return }
        let docRef = db.collection("users").document(uid).collection("favorites").document(designId)
        
        if favoriteIds.contains(designId) {
            docRef.delete()
        } else {
            docRef.setData(["addedAt": Date(), "designId": designId])
        }
    }
    
    func isFavorite(_ design: NailDesign) -> Bool {
        guard let id = design.id else { return false }
        return favoriteIds.contains(id)
    }
    
    private func loadSamples() {
        self.designs = NailDesign.samples
    }
}
