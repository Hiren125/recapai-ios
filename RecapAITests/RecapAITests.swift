//
//  RecapAITests.swift
//  RecapAITests
//
//  Created by Hiren on 15/07/26.
//

import XCTest

@testable import Recap_AI

final class RecapAITests: XCTestCase {

    func test_filteredMeetings_returnMatchingResults() {
       //Arrange
        let viewModel = MeetingListViewModel()
        
        viewModel.searchText = "Budget"
        
        let meeting1 = Meeting(title: "Budget Review")
        let meeting2 = Meeting(title: "Team Standing")
        
        //act
        let results = viewModel.filteredMeetings([meeting1,meeting2])
        
        //Assert
        XCTAssertEqual(results.count,1)
        XCTAssertEqual(results.first?.title,"Budget Review")
        
        
    }
    
    
    func test_filteredMeetings_returnsAll_whenSearchEmpty(){
        
        let viewModel = MeetingListViewModel()
        
        viewModel.searchText = ""
        
        let meeting1 = Meeting(title: "Budget Review")
        let meeting2 = Meeting(title: "Team Standing")
        
        let results = viewModel.filteredMeetings([meeting1,meeting2])
        
        XCTAssertEqual(results.count, 2)
    }
    
    
    func test_meeting_defaultValues(){
        
        let meeting = Meeting()
        
        XCTAssertEqual(meeting.title,"New Meeting")
        XCTAssertEqual(meeting.transcript,"")
        XCTAssertEqual(meeting.durationSeconds,0)
        XCTAssertNil(meeting.audioFileURL)
        
    }
}
