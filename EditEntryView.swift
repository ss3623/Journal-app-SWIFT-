import SwiftUI
import AppKit

struct EditEntryView: View {
    @Environment(\.dismiss) var dismiss
    let entry: JournalEntry
    @ObservedObject var manager: JournalManager
    var onSave: () -> Void
    
    @State private var title: String
    @State private var content: String
    @State private var selectedDate: Date
    @State private var selectedMood: Mood?
    
    init(entry: JournalEntry, manager: JournalManager, onSave: @escaping () -> Void = {}) {
        self.entry = entry
        self.manager = manager
        self.onSave = onSave
        
        _title = State(initialValue: entry.title)
        _content = State(initialValue: entry.content)
        _selectedDate = State(initialValue: entry.date)
        _selectedMood = State(initialValue: entry.mood)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                        TextField("Entry title", text: $title)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal)
                    
                    // Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date")
                            .font(.headline)
                        DatePicker("Entry date", selection: $selectedDate, displayedComponents: [.date])
                    }
                    .padding(.horizontal)
                    
                    // Mood
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mood")
                            .font(.headline)
                        HStack(spacing: 16) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                Button(action: {
                                    selectedMood = mood
                                }) {
                                    VStack(spacing: 4) {
                                        Text(mood.rawValue)
                                            .font(.system(size: 40))
                                        Text(mood.name)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 70, height: 70)
                                    .background(
                                        selectedMood == mood ? mood.color.opacity(0.3) : Color.clear
                                    )
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.headline)
                        
                        TextEditor(text: $content)
                            .frame(height: 400)
                            .border(Color.gray.opacity(0.3))
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        if let index = manager.entries.firstIndex(where: { $0.id == entry.id }) {
            manager.entries[index].title = title
            manager.entries[index].content = content
            manager.entries[index].date = selectedDate
            manager.entries[index].mood = selectedMood
            manager.saveEntries()
        }
        onSave()
        dismiss()
    }
}
