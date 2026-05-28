//
//  RecordingView.swift
//  Recap AI
//
//  Created by Hiren on 27/05/26.
//

import SwiftUI
import SwiftData
 
struct RecordingView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = RecordingViewModel()
 
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
 
                // Mic button — tap to start recording
                Button {
                    if case .idle = viewModel.phase {
                        Task { await viewModel.requestPermissionAndStart() }
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.15))
                            .frame(width: 140, height: 140)
                            .scaleEffect(isRecording ? 1.1 : 1.0)
                            .animation(
                                .easeInOut(duration: 1).repeatForever(autoreverses: true),
                                value: isRecording
                            )
 
                        Image(systemName: iconName)
                            .font(.system(size: 56))
                            .foregroundStyle(isRecording ? .red : .secondary)
                    }
                }
                .buttonStyle(.plain)
 
                // Tap hint shown only when idle
                if case .idle = viewModel.phase {
                    Text("Tap mic to start recording")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
 
                // Timer
                Text(formattedTime(viewModel.recordingTime))
                    .font(.system(size: 48, weight: .thin, design: .monospaced))
 
                // Controls — shown only while recording or paused
                HStack(spacing: 32) {
                    if isRecording || viewModel.audioState == .paused {
                        Button {
                            viewModel.togglePause()
                        } label: {
                            Label(
                                viewModel.audioState == .paused ? "Resume" : "Pause",
                                systemImage: viewModel.audioState == .paused ? "play.circle" : "pause.circle"
                            )
                        }
 
                        Button {
                            Task { await viewModel.stopAndTranscribe(context: context) }
                        } label: {
                            Label("Stop", systemImage: "stop.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
                .font(.title3)
 
                // Status
                switch viewModel.phase {
                case .idle:
                    EmptyView()
                case .recording:
                    Label("Recording…", systemImage: "mic.fill")
                        .foregroundStyle(.red)
                case .transcribing:
                    HStack {
                        ProgressView()
                        Text("Transcribing…")
                    }
                case .summarizing:
                    HStack {
                        ProgressView()
                        Text("Generating summary…")
                    }
                case .done:
                    Label("Done!", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                case .error(let msg):
                    Text(msg)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
 
                // Debug — remove after recording works
                Text("Phase: \(String(describing: viewModel.phase))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
 
                Spacer()
            }
            .navigationTitle("New Meeting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancel()
                        dismiss()
                    }
                }
            }
            .onChange(of: viewModel.phase) { _, phase in
                if case .done = phase {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { dismiss() }
                }
            }
        }
    }
 
    private var isRecording: Bool {
        if case .recording = viewModel.phase { return true }
        return false
    }
 
    private var iconName: String {
        switch viewModel.phase {
        case .recording: return "mic.fill"
        case .transcribing: return "waveform"
        case .summarizing: return "sparkles"
        case .done: return "checkmark"
        case .error: return "exclamationmark.triangle"
        default: return "mic"
        }
    }
 
    private func formattedTime(_ seconds: TimeInterval) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%02d:%02d", m, s)
    }
}
