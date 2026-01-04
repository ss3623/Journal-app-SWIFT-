import SwiftUI
import AppKit

struct AddEntryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: JournalManager
    
    @State private var title = ""
    @State private var attributedContent = NSAttributedString(string: "")
    @State private var selectedDate = Date()
    @State private var selectedMood: Mood?
    
    var body: some View {
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
                    
                    FormattingToolbar(
                        onBold: { applyFormatting(.bold) },
                        onItalic: { applyFormatting(.italic) },
                        onUnderline: { applyFormatting(.underline) }
                    )
                    
                    RichTextEditor(attributedText: $attributedContent)
                        .frame(height: 400)
                        .border(Color.gray.opacity(0.3))
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("New Entry")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveEntry()
                }
                .disabled(title.isEmpty)
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
        manager.addEntry(
            title: title,
            content: attributedContent.string,
            date: selectedDate,
            attributedContent: contentData,
            mood: selectedMood
        )
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
