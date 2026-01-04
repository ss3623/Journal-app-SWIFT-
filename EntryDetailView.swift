import SwiftUI
import AppKit

struct EntryDetailView: View {
    let entry: JournalEntry
    @ObservedObject var manager: JournalManager
    @State private var showingEditView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(entry.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                if let attributedData = entry.attributedContent,
                   let attributedString = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: attributedData) {
                    AttributedTextView(attributedString: attributedString)
                } else {
                    Text(entry.content)
                        .font(.body)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Entry")
        .toolbar {
            Button("Edit") {
                showingEditView = true
            }
        }
        .navigationDestination(isPresented: $showingEditView) {
            EditEntryView(entry: entry, manager: manager)
        }
    }
}



