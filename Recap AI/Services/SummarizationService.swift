//
//  SummarizationService.swift
//  Recap AI
//
//  Created by Hiren on 03/06/26.
//

import Foundation

struct SummarizationService {

    private let apiKey: String

    init(apiKey: String = APIKeys.openAI) {
        self.apiKey = apiKey
    }

    func summarize(transcript: String) async throws -> MeetingSummaryDTO {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let systemPrompt = """
        You are an expert meeting notes assistant.
        Analyze the transcript and return ONLY a JSON object — no markdown, no backticks, no preamble.

        Required JSON schema:
        {
          "overview": "2-3 sentence summary of the meeting",
          "actionItems": ["action item with owner if mentioned"],
          "followUpTasks": ["follow-up with no specific owner"],
          "keyDecisions": ["decision made during meeting"],
          "participants": ["names mentioned in transcript"]
        }

        If a category has no content, return an empty array []. Never return null.
        """

        let body: [String: Any] = [
            "model": "gpt-4o",
            "max_tokens": 1000,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": "Transcript:\n\(transcript)"]
            ],
            "response_format": ["type": "json_object"]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown"
            throw SummarizationError.apiError(errorBody)
        }

        struct ChatResponse: Decodable {
            struct Choice: Decodable {
                struct Message: Decodable { let content: String }
                let message: Message
            }
            let choices: [Choice]
        }

        let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
        guard let content = chatResponse.choices.first?.message.content,
              let contentData = content.data(using: .utf8) else {
            throw SummarizationError.emptyResponse
        }

        return try JSONDecoder().decode(MeetingSummaryDTO.self, from: contentData)
    }
}

enum SummarizationError: LocalizedError {
    case apiError(String)
    case emptyResponse
    var errorDescription: String? {
        switch self {
        case .apiError(let msg): return "Summarization failed: \(msg)"
        case .emptyResponse: return "No summary returned."
        }
    }
}
