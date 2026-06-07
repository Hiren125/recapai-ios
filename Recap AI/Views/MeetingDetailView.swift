//
//  MeetingDetailView.swift
//  Recap AI
//
//  Created by Hiren on 05/06/26.
//


import SwiftUI

struct MeetingDetailView: View {
    let meeting: Meeting
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            Picker("View", selection: $selectedTab) {
                Text("Summary").tag(0)
                Text("Transcript").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            TabView(selection: $selectedTab) {
                SummaryView(summary: meeting.summary)
                    .tag(0)

                ScrollView {
                    Text(meeting.transcript.isEmpty
                         ? "No transcript available."
                         : meeting.transcript)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle(meeting.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
