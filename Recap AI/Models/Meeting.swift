//
//  Meeting.swift
//  Recap AI
//
//  Created by Hiren on 20/05/26.
//

import Foundation
import SwiftData

@Model
final class Meeting {
    var id: UUID
    var title: String
    var date: Date
    var audioFileURL: URL?
    var transcript: String
    var summary: MeetingSummary?
    var durationSeconds: Double

    init(title: String = "New Meeting") {
        self.id = UUID()
        self.title = title
        self.date = Date()
        self.transcript = ""
        self.durationSeconds = 0
    }
}
