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
    
    var body: some Scene {
        WindowGroup {
            MeetingListView()
        }
        .modelContainer(for: [Meeting.self, MeetingSummary.self])
    }
}
