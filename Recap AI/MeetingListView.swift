//
//  ContentView.swift
//  Recap AI
//
//  Created by Hiren on 20/05/26.
//

import SwiftUI
import SwiftData

struct MeetingListView: View {
    @Query(sort: \Meeting.date, order: .reverse) private var meetings: [Meeting]
    @State private var showRecording = false

    var body: some View {
        NavigationStack {
            List(meetings) { meeting in
                VStack(alignment: .leading) {
                    Text(meeting.title).font(.headline)
                    Text(meeting.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Meetings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showRecording = true
                    } label: {
                        Image(systemName: "mic.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showRecording) {
                RecordingView()
            }
        }
    }
}
