//
//  Recap_AIApp.swift
//  Recap AI
//
//  Created by Hiren on 20/05/26.
//

import SwiftUI
import SwiftData

@main
struct Recap_AIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MeetingListView()
        }
        .modelContainer(for: [Meeting.self, MeetingSummary.self])
    }
}
