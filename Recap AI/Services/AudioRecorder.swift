//
//  AudioRecorder.swift
//  Recap AI
//
//  Created by Hiren on 20/05/26.
//

import Foundation
import AVFoundation


final class AudioRecorder: NSObject {
    
    enum RecordingState {
        case idle,recording,paused,finished
    }
    
    var state : RecordingState = .idle
    var currentTime : TimeInterval = 0
    var audioFileURL: URL?
    var errorMessage : String?
    
    private var recorder : AVAudioRecorder?
    private var timer: Timer?
    
    func requestPermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }
    
    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            let url = newAudioFileURL()
            let settings:[String:Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.delegate = self
            recorder?.record()
            
            audioFileURL = url
            state = .recording
            startTimer()
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func stopRecording() {
        recorder?.stop()
        stopTimer()
        state = .finished
    }
    
    func pauseRecording() {
        recorder?.pause()
        stopTimer()
        state = .paused
    }
    
    func resumeRecording() {
        recorder?.stop()
        recorder = nil
        stopTimer()
        currentTime = 0
        audioFileURL = nil
        state = .idle
    }
    
    
    private func newAudioFileURL() -> URL{
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("\(UUID().uuidString).m4a")
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.currentTime = self?.recorder?.currentTime ?? 0
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}


extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            errorMessage = "Recording failed to save."
            state = .idle
        }
    }
}
