import SwiftUI

@main
struct journalApp: App {
    var body: some Scene {
        WindowGroup {
            EntryListView()
        }
        .defaultSize(width: 1200, height: 800)
    }
}
