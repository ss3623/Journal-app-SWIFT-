//
//  EntryListView.swift
//  journal
//
//  Created by Sania Singh on 04/01/2026.
//

import Foundation
import SwiftUI
import AppKit

struct EntryListView: View {
    @StateObject private var manager = JournalManager()
    @State private var showingAddEntry = false
    @State private var selectedEntry: JournalEntry?
    @State private var showingEditEntry = false
    
    var body: some View {
        NavigationView {
            // Sidebar - List
            List {
                ForEach(manager.entries) { entry in
                    Button(action: {
                        selectedEntry = entry
                    }) {
                        HStack(spacing: 12) {
                            if let mood = entry.mood {
                                Text(mood.rawValue)
                                    .font(.title)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(entry.title)
                                    .font(.headline)
                                
                                Text(entry.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                
                                Text(entry.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            entry.mood?.color.opacity(0.1) ?? Color.clear
                        )
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: manager.deleteEntry)
            }
            .navigationTitle("My Journal")
            .toolbar {
                Button(action: { showingAddEntry = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView(manager: manager)
            }
            
            // Detail view
            if let entry = selectedEntry {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(entry.title)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Text(entry.date, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    if let mood = entry.mood {
                                        Text(mood.rawValue)
                                            .font(.title2)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Button("Edit") {
                                showingEditEntry = true
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        Divider()
                        
                        Text(entry.content)
                            .font(.body)
                        
                        Spacer()
                    }
                    .padding()
                }
                .sheet(isPresented: $showingEditEntry) {
                    EditEntryView(entry: entry, manager: manager, onSave: {
                        // Refresh selected entry after edit
                        if let updatedEntry = manager.entries.first(where: { $0.id == entry.id }) {
                            selectedEntry = updatedEntry
                        }
                    })
                }
            } else {
                VStack {
                    Image(systemName: "book")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Select an entry")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
