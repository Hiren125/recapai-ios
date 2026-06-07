//
//  ContentView.swift
//  Recap AI
//
//  Created by Hiren on 20/05/26.
//


import SwiftUI
import SwiftData

struct MeetingListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Meeting.date, order: .reverse) private var meetings: [Meeting]
    @State private var viewModel = MeetingListViewModel()
    @State private var showRecording = false

    var body: some View {
        NavigationStack {
            Group {
                if meetings.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(viewModel.filteredMeetings(meetings)) { meeting in
                            NavigationLink(destination: MeetingDetailView(meeting: meeting)) {
                                MeetingRowView(meeting: meeting)
                            }
                        }
                        .onDelete { indexSet in
                            let filtered = viewModel.filteredMeetings(meetings)
                            indexSet.forEach {
                                viewModel.deleteMeeting(filtered[$0], context: context)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $viewModel.searchText, prompt: "Search meetings")
                }
            }
            .navigationTitle("Meetings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showRecording = true } label: {
                        Image(systemName: "mic.circle.fill").font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showRecording) {
                RecordingView()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "waveform.circle")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("No meetings yet")
                .font(.title2).fontWeight(.medium)
            Text("Tap the mic button to record your first meeting")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Start Recording") { showRecording = true }
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct MeetingRowView: View {
    let meeting: Meeting

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(meeting.title)
                .font(.headline)
                .lineLimit(1)
            HStack {
                Text(meeting.date.formatted(date: .abbreviated, time: .shortened))
                Spacer()
                if meeting.summary != nil {
                    Label("AI Summary", systemImage: "sparkles")
                        .font(.caption)
                        .foregroundStyle(.purple)
                } else if !meeting.transcript.isEmpty {
                    Label("Transcribed", systemImage: "text.bubble")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
