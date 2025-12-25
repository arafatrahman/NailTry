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
    
    // Flag to prevent notifications when the app first opens and loads existing data
    private var isFirstLoad = true
    
    init() {
        fetchDesigns()
        fetchFavorites()
    }
    
    func fetchDesigns() {
        // CHANGED: Use addSnapshotListener for Real-Time Updates
        db.collection("nail_styles").addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error fetching designs: \(error.localizedDescription)")
                // If real data fails or is empty on first load, use samples
                if self.designs.isEmpty { self.loadSamples() }
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            // 1. Update the data source
            let fetchedDesigns = snapshot.documents.compactMap { try? $0.data(as: NailDesign.self) }
            
            if !fetchedDesigns.isEmpty {
                self.designs = fetchedDesigns
            } else {
                self.loadSamples()
            }
            
            // 2. Check for NEW additions (Notifications)
            if self.isFirstLoad {
                // Don't notify for data that was already there on launch
                self.isFirstLoad = false
            } else {
                // Loop through changes to find added documents
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        if let newDesign = try? diff.document.data(as: NailDesign.self) {
                            print("🔔 New Design Detected: \(newDesign.name)")
                            NotificationManager.shared.sendNewStyleNotification(
                                name: newDesign.name,
                                category: newDesign.category
                            )
                        }
                    }
                }
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
