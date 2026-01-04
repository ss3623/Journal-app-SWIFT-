import Foundation
import Combine
import SwiftUI

class JournalManager: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    private let saveKey = "SavedEntries"
    
    init() {
        loadEntries()
    }
    
    func addEntry(title: String, content: String, date: Date, attributedContent: Data? = nil) {
        let newEntry = JournalEntry(title: title, content: content, date: date, attributedContent: attributedContent)
        entries.insert(newEntry, at: 0)
        saveEntries()
    
    
    }
    
    func deleteEntry(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        saveEntries()
    }
    
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func loadEntries() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: savedData) {
            entries = decoded
        }
    }
}
