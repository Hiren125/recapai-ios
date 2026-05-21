//
//  MeetingSummary.swift
//  Recap AI
//
//  Created by Hiren on 20/05/26.
//

import Foundation
import SwiftData

@Model
final class MeetingSummary {
    var overview: String
    var actionItems: [String]
    var followUpTasks: [String]
    var keyDecisions: [String]
    var participants: [String]

    init(overview: String, actionItems: [String],
         followUpTasks: [String], keyDecisions: [String],
         participants: [String]) {
        self.overview = overview
        self.actionItems = actionItems
        self.followUpTasks = followUpTasks
        self.keyDecisions = keyDecisions
        self.participants = participants
    }
}

// Codable mirror — used to decode GPT-4o JSON response
struct MeetingSummaryDTO: Codable {
    let overview: String
    let actionItems: [String]
    let followUpTasks: [String]
    let keyDecisions: [String]
    let participants: [String]
}
