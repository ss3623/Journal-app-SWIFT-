import SwiftUI

enum Mood: String, Codable, CaseIterable {
    case great = "😊"
    case good = "🙂"
    case okay = "😐"
    case bad = "😔"
    case terrible = "😢"
    
    var color: Color {
        switch self {
        case .great:
            return .green
        case .good:
            return .mint
        case .okay:
            return .yellow
        case .bad:
            return .orange
        case .terrible:
            return .red
        }
    }
    
    var name: String {
        switch self {
        case .great:
            return "Great"
        case .good:
            return "Good"
        case .okay:
            return "Okay"
        case .bad:
            return "Bad"
        case .terrible:
            return "Terrible"
        }
    }
}
