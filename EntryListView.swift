//
//  EntryListView.swift
//  journal
//
//  Created by Sania Singh on 04/01/2026.
//

import Foundation
import SwiftUI

struct EntryListView: View {
    @StateObject private var manager = JournalManager()
    @State private var showingAddEntry = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(manager.entries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry, manager: manager)) {
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
                        .padding(.vertical, 4)
                    }
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
        }
    }
}
