# Recap AI

An iOS app that records meetings, transcribes audio with OpenAI Whisper,
and generates structured summaries using GPT-4o.

## Features
- 🎙️ One-tap recording with pause/resume
- 📝 Automatic transcription via Whisper API
- ✨ AI-generated summaries: overview, action items, follow-ups, decisions
- ✅ Checkable action items
- 📄 Export and share as PDF
- 🔍 Search across all meetings
- 🔐 API key stored securely in iOS Keychain

## Tech Stack
- SwiftUI + SwiftData (iOS 17+)
- AVFoundation for audio recording
- OpenAI Whisper API for transcription
- GPT-4o with JSON mode for structured summarization
- PDFKit for export
- iOS Keychain for secure API key storage

## Requirements
- iOS 17+
- Xcode 15+
- OpenAI API key (get one at platform.openai.com)

## Setup
1. Clone the repo
2. Open `Recap AI.xcodeproj` in Xcode
3. Run on device (simulator has limited mic support)
4. Go to Settings tab → enter your OpenAI API key
5. Start recording

## Architecture
MVVM with SwiftData persistence. No backend required — all AI calls made
directly from the app using URLSession async/await.

MeetingNotes/
├── Models/          # Meeting, MeetingSummary (SwiftData)
├── Services/        # AudioRecorder, TranscriptionService, SummarizationService
├── ViewModels/      # RecordingViewModel, MeetingListViewModel
└── Views/           # MeetingListView, RecordingView, MeetingDetailView, SummaryView

## API Cost
Approx $0.06 per 10-min meeting (Whisper) + ~$0.005 per summary (GPT-4o).
Full testing budget under $5.

## Demo
[Add your demo video link or GIF here]
