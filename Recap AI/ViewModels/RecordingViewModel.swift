//
//  RecordingViewModel.swift
//  Recap AI
//
//  Created by Hiren on 27/05/26.
//

import Foundation
import SwiftData

@Observable
final class RecordingViewModel {
    
    enum Phase : Equatable{
        case idle, recording, transcribing, summarizing, done
        case error(String)
    }
    
    var phase : Phase = .idle
    var meeting : Meeting?
    
    private let recorder = AudioRecorder()
    private let transcriptionService = TranscriptionService()
    
    var audioState:
    AudioRecorder.RecordingState{
        recorder.state
    }
    var recordingTime : TimeInterval {
        recorder.currentTime
    }
    
    func requestPermissionAndStart() async {
        let granted = await
        recorder.requestPermission()
        guard granted else {
            phase = .error("Microphone access denied. Enable it in Settings.")
            return
        }
        recorder.startRecording()
        phase = .recording
    }
    
    func stopAndTranscribe(context : ModelContext) async {
        
        recorder.stopRecording()
        guard let audioURL = recorder.audioFileURL else {
            phase = .error("No Audio file found")
            return
        }
        
        let newMeeting = Meeting()
        context.insert(newMeeting)
        newMeeting.audioFileURL = audioURL
        newMeeting.durationSeconds = recorder.currentTime
        meeting = newMeeting
        
        phase = .transcribing
        do {
            let transcript = try await transcriptionService.transcribe(audioURL: audioURL)
            newMeeting.transcript = transcript
            try? context.save()
            phase = .done
        } catch {
            phase = .error(error.localizedDescription)
        }
        recorder.reset()
    }
    
    func togglePause() {
        if recorder.state == .recording {
            recorder.pauseRecording()
        }
        else {
            recorder.resumeRecording()
        }
    }
    
    func cancel(){
        recorder.reset()
        phase = .idle
        meeting = nil
    }
    
   
}
