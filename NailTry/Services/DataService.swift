// Services/DataService.swift
import Foundation
import Combine
import FirebaseFirestore

class DataService: ObservableObject {
    @Published var designs: [NailDesign] = []
    
    private let db = Firestore.firestore()
    
    func fetchDesigns() {
        print("🔥 Fetching designs from Firestore...")
        
        db.collection("nail_styles").getDocuments { [weak self] snapshot, error in
            
            // 1. Handle Error (Network issues, permission denied)
            if let error = error {
                print("❌ Firestore Error: \(error.localizedDescription)")
                self?.loadSamples()
                return
            }
            
            // 2. Handle Success
            if let docs = snapshot?.documents, !docs.isEmpty {
                print("✅ Found \(docs.count) designs in Firestore.")
                self?.designs = docs.compactMap { try? $0.data(as: NailDesign.self) }
            } else {
                // 3. Handle Empty Database (Load Samples)
                print("⚠️ Firestore is empty. Loading sample data.")
                self?.loadSamples()
            }
        }
    }
    
    // Helper to load hardcoded samples so the screen isn't blank
    private func loadSamples() {
        self.designs = NailDesign.samples
        print("📂 Loaded \(self.designs.count) sample designs.")
    }
}
