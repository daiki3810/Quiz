import SwiftUI
import SwiftData

@main
struct QuizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Translation.self)
    }
}
