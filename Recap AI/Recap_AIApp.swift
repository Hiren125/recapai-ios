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
            TabView {
                MeetingListView()
                    .tabItem {
                        Label("Meetings", systemImage: "waveform")
                    }
 
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
        .modelContainer(for: [Meeting.self, MeetingSummary.self])
    }
}
