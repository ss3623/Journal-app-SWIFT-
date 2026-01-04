//
//  FormattingToolbar.swift
//  journal
//
//  Created by Sania Singh on 04/01/2026.
//

import SwiftUI
import AppKit

struct FormattingToolbar: View {
    let onBold: () -> Void
    let onItalic: () -> Void
    let onUnderline: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onBold) {
                Image(systemName: "bold")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.bordered)
            
            Button(action: onItalic) {
                Image(systemName: "italic")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.bordered)
            
            Button(action: onUnderline) {
                Image(systemName: "underline")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
