//
//  TranscriptionService.swift
//  Recap AI
//
//  Created by Hiren on 27/05/26.
//

import Foundation

struct TranscriptionService {
    
    private let apiKey: String
    private let urlString : String = "https://api.openai.com/v1/audio/transcriptions"
    
    
    
    init(apiKey: String = APIKeys.openAI) {
        self.apiKey = apiKey
    }
    
    func transcribe(audioURL:URL) async throws -> String{
        
        let attributes = try FileManager.default.attributesOfItem(atPath: audioURL.path)
        let fileSize = attributes[.size] as? Int64 ?? 0
        guard fileSize < 25_000_000 else {
            throw TranscriptionError.apiError("Recording too large (max 25MB, ~90 minutes)")
        }

        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url:url)
        request.httpMethod = "Post"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        
        let audioData = try Data(contentsOf: audioURL)
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-1\r\n".data(using: .utf8)!)

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
        else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown"
            throw
            TranscriptionError.apiError(errorBody)
        }
     
        let decoded = try JSONDecoder().decode(WhisperResponse.self, from: data)
        return decoded.text
    }
    
}


struct WhisperResponse : Decodable{
    let text : String
}


enum TranscriptionError : LocalizedError {
    case apiError(String)
    var errorDescription: String? {
        if case .apiError(let message) = self {
            return "Transcription failed: \(message)"
        }
        return nil
    }
}
