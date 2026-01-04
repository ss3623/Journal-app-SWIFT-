import SwiftUI
import AppKit

struct AddEntryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: JournalManager
    
    @State private var title = ""
    @State private var attributedContent = NSAttributedString(string: "")
    @State private var selectedDate = Date()
    
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
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
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
    
    private func saveEntry() {
        let contentData = try? NSKeyedArchiver.archivedData(withRootObject: attributedContent, requiringSecureCoding: false)
        manager.addEntry(title: title, content: attributedContent.string, date: selectedDate, attributedContent: contentData)
        dismiss()
    }
    
    enum FormattingType {
        case bold, italic, underline
    }
}

extension NSMutableAttributedString {
    func applyFontTraits(_ traits: NSFontTraitMask, range: NSRange) {
        beginEditing()
        enumerateAttribute(.font, in: range, options: []) { value, subRange, _ in
            guard let font = value as? NSFont else { return }
            let newFont = NSFontManager.shared.convert(font, toHaveTrait: traits)
            removeAttribute(.font, range: subRange)
            addAttribute(.font, value: newFont, range: subRange)
        }
        endEditing()
    }
}
