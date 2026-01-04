//
//  JournalEntry.swift
//  journal
//
//  Created by Sania Singh on 04/01/2026.
//

// represents a single journal entry.
import Foundation

struct JournalEntry : Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var attributedContent: Data?
    
    
}
