//
//  SessionSectionsTests.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 06.08.24.
//

import XCTest
@testable import BetterEveryDay

final class SessionSectionsTests: XCTestCase {
    func testInit() {
        let sessionSections = Session()
        
        XCTAssert(sessionSections.segments.isEmpty, "Is not created empty")
    }
    
    func testCreateNextSection() {
        let sessionSections = Session()
        
        sessionSections.next()
        XCTAssertEqual(sessionSections.segments.count, 1)
        guard let last = sessionSections.segments.last else {
            XCTFail()
            return
        }
        XCTAssertEqual(last.category, .Focus, "")
        XCTAssertNil(last.finishedAt)
    }
    
    func testFinishUpPreviousSession() {
        let sessionSections = Session()
        sessionSections.segments.append(.init(category: .Focus))
        
        sessionSections.next()
        
        XCTAssertEqual(sessionSections.segments.count, 2)
        guard let first = sessionSections.segments.first else {
            XCTFail()
            return
        }
        guard let last = sessionSections.segments.last else {
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
        let sessionSections = Session()
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        sessionSections.segments.append(.init(category: .Focus, startedAt: thirtyMinAgo))
        sessionSections.next()
        
        XCTAssertEqual(sessionSections.availableBreak, 600, accuracy: 0.001)
    }
    
    func testSessionWithMultipleEntries() {
        let sessionSections = Session()
        
        let thirtyMinSession = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        sessionSections.segments.append(.init(category: .Focus, startedAt: thirtyMinSession))
        sessionSections.next()
        
        XCTAssertEqual(sessionSections.availableBreak, 600, accuracy: 0.001)
        
        let _ = sessionSections.segments.popLast()
        let fifteenMinSession = Calendar.current.date(byAdding: .minute, value: -15, to: .now)!
        sessionSections.segments.append(.init(category: .Pause, startedAt: fifteenMinSession))
        sessionSections.next()
        
        XCTAssertEqual(sessionSections.availableBreak, -300, accuracy: 0.001)
        
        let _ = sessionSections.segments.popLast()
        let OneHourSession = Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
        sessionSections.segments.append(.init(category: .Focus, startedAt: OneHourSession))
        sessionSections.next()
        
        XCTAssertEqual(sessionSections.availableBreak, 900, accuracy: 0.001)
    }
    
    func testGetSessionStats() {
        
    }
}
