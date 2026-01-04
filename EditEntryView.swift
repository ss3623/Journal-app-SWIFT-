//
//  EditEntryView.swift
//  journal
//
//  Created by Sania Singh on 04/01/2026.
//

import SwiftUI
import AppKit

struct EditEntryView: View {
    @Environment(\.dismiss) var dismiss
    let entry: JournalEntry
    @ObservedObject var manager: JournalManager
    
    @State private var title: String
    @State private var attributedContent: NSAttributedString
    @State private var selectedDate: Date
    
    init(entry: JournalEntry, manager: JournalManager) {
        self.entry = entry
        self.manager = manager
        
        _title = State(initialValue: entry.title)
        _selectedDate = State(initialValue: entry.date)
        
        if let data = entry.attributedContent,
           let attrString = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data) {
            _attributedContent = State(initialValue: attrString)
        } else {
            _attributedContent = State(initialValue: NSAttributedString(string: entry.content))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Entry title", text: $title)
                    }
                    
                    Section(header: Text("Date")) {
                        DatePicker("Entry date", selection: $selectedDate, displayedComponents: [.date])
                    }
                }
                .frame(height: 150)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Content")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    FormattingToolbar(
                        onBold: { applyFormatting(.bold) },
                        onItalic: { applyFormatting(.italic) },
                        onUnderline: { applyFormatting(.underline) }
                    )
                    
                    RichTextEditor(attributedText: $attributedContent)
                        .frame(minHeight: 300)
                        .border(Color.gray.opacity(0.3))
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
    
    private func applyFormatting(_ type: FormattingType) {
        let mutableString = NSMutableAttributedString(attributedString: attributedContent)
        let range = NSRange(location: 0, length: mutableString.length)
        
        switch type {
        case .bold:
            mutableString.applyFontTraits(.boldFontMask, range: range)
        case .italic:
            mutableString.applyFontTraits(.italicFontMask, range: range)
        case .underline:
            mutableString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        
        attributedContent = mutableString
    }
    
    private func saveChanges() {
        if let index = manager.entries.firstIndex(where: { $0.id == entry.id }) {
            let contentData = try? NSKeyedArchiver.archivedData(withRootObject: attributedContent, requiringSecureCoding: false)
            manager.entries[index].title = title
            manager.entries[index].content = attributedContent.string
            manager.entries[index].date = selectedDate
            manager.entries[index].attributedContent = contentData
            manager.saveEntries()
        }
        dismiss()
    }
    
    enum FormattingType {
        case bold, italic, underline
    }
}
