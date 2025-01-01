//
//  SessionSegmentsTests.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 06.08.24.
//

import XCTest
@testable import BetterEveryDayCore


final class SessionSegmentsTests: XCTestCase {
    func testGetDurationOfFinishedSessionSegment() {
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        let sessionSegment = SessionSegment(category: .Focus, startedAt: oneHourAgo, finishedAt: thirtyMinAgo)
        
        XCTAssertEqual(sessionSegment.duration, 1_800, accuracy: 0.001)
    }
    
    func testGetDurationOfRunningSessionSegment() {
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        let sessionSegment = SessionSegment(category: .Focus, startedAt: thirtyMinAgo)
        
        XCTAssertEqual(sessionSegment.duration, 1_800, accuracy: 0.001)
    }
    
    func testSegmentIsRunning() {
        let running = SessionSegment(category: .Focus, startedAt: .now)
        
        XCTAssertTrue(running.isRunning)
    }
    
    func testSegmentIsFinished() {
        let finished = SessionSegment(category: .Focus, startedAt: .now, finishedAt: .now)
        
        XCTAssertFalse(finished.isRunning)
    }
}
