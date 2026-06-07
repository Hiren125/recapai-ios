//
//  MeetingListViewModel.swift
//  Recap AI
//
//  Created by Hiren on 05/06/26.
//

import Foundation
import SwiftData

@Observable
final class MeetingListViewModel {
    var searchText = ""

    func deleteMeeting(_ meeting: Meeting, context: ModelContext) {
        if let url = meeting.audioFileURL {
            try? FileManager.default.removeItem(at: url)
        }
        context.delete(meeting)
        try? context.save()
    }

    func filteredMeetings(_ meetings: [Meeting]) -> [Meeting] {
        guard !searchText.isEmpty else { return meetings }
        return meetings.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.transcript.localizedCaseInsensitiveContains(searchText)
        }
    }
}
