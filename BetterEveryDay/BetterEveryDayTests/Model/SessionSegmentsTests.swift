//
//  SessionSegmentsTests.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 06.08.24.
//

import XCTest
@testable import BetterEveryDay

final class SessionSegmentsTests: XCTestCase {
    func testInit() {
        let sessionSegments = Session()
        
        XCTAssert(sessionSegments.segments.isEmpty, "Is not created empty")
    }
    
    func testCreateNextSection() {
        let sessionSegments = Session()
        
        sessionSegments.next()
        XCTAssertEqual(sessionSegments.segments.count, 1)
        guard let last = sessionSegments.segments.last else {
            XCTFail()
            return
        }
        XCTAssertEqual(last.category, .Focus, "")
        XCTAssertNil(last.finishedAt)
    }
    
    func testFinishUpPreviousSession() {
        let sessionSegments = Session()
        sessionSegments.segments.append(.init(category: .Focus))
        
        sessionSegments.next()
        
        XCTAssertEqual(sessionSegments.segments.count, 2)
        guard let first = sessionSegments.segments.first else {
            XCTFail()
            return
        }
        guard let last = sessionSegments.segments.last else {
            XCTFail()
            return
        }
        XCTAssertEqual(first.category, .Focus, "")
        XCTAssertNotNil(first.finishedAt)
        XCTAssertEqual(last.category, .Pause, "")
        XCTAssertNil(last.finishedAt)
    }
    
    func testGetDurationOfFinishedSessionSection() {
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        let sessionSection = SessionSegment(category: .Focus, startedAt: thirtyMinAgo, finishedAt: .now)
        
        XCTAssertEqual(sessionSection.duration, 1_800, accuracy: 0.001)
    }
    
    func testGetPauseLength() {
        let sessionSegments = Session()
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        sessionSegments.segments.append(.init(category: .Focus, startedAt: thirtyMinAgo))
        sessionSegments.next()
        
        XCTAssertEqual(sessionSegments.availableBreak, 600, accuracy: 0.001)
    }
    
    func testSessionWithMultipleEntries() {
        let sessionSegments = Session()
        
        let thirtyMinSession = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        sessionSegments.segments.append(.init(category: .Focus, startedAt: thirtyMinSession))
        sessionSegments.next()
        
        XCTAssertEqual(sessionSegments.availableBreak, 600, accuracy: 0.001)
        
        let _ = sessionSegments.segments.popLast()
        let fifteenMinSession = Calendar.current.date(byAdding: .minute, value: -15, to: .now)!
        sessionSegments.segments.append(.init(category: .Pause, startedAt: fifteenMinSession))
        sessionSegments.next()
        
        XCTAssertEqual(sessionSegments.availableBreak, -300, accuracy: 0.001)
        
        let _ = sessionSegments.segments.popLast()
        let OneHourSession = Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
        sessionSegments.segments.append(.init(category: .Focus, startedAt: OneHourSession))
        sessionSegments.next()
        
        XCTAssertEqual(sessionSegments.availableBreak, 900, accuracy: 0.001)
    }
    
    func testGetSessionStats() {
        
    }
}
