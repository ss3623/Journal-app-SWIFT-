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
        .sheet(isPresented: $showingEditView) {
            EditEntryView(entry: entry, manager: manager)
        }
    }
}

struct AttributedTextView: NSViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textStorage?.setAttributedString(attributedString)
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(attributedString)
    }
}
