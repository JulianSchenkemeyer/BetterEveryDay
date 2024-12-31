//
//  SessionTests.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 17.08.24.
//

import XCTest
@testable import BetterEveryDayCore


final class SessionTests: XCTestCase {
    func testInit() {
        let session = ThirdTimeSession()
        
        XCTAssert(session.segments.isEmpty, "Is not created empty")
    }
    
    func testCreateNextSection() {
        let session = ThirdTimeSession()
        
        session.next()
        XCTAssertEqual(session.segments.count, 1)
        guard let last = session.segments.last else {
            XCTFail()
            return
        }
        XCTAssertEqual(last.category, .Focus, "")
        XCTAssertNil(last.finishedAt)
    }
    
    func testFinishUpPreviousSession() {
        let session = ThirdTimeSession()
        session.segments.append(.init(category: .Focus))
        
        session.next()
        
        XCTAssertEqual(session.segments.count, 2)
        guard let first = session.segments.first else {
            XCTFail()
            return
        }
        guard let last = session.segments.last else {
            XCTFail()
            return
        }
        XCTAssertEqual(first.category, .Focus, "")
        XCTAssertNotNil(first.finishedAt)
        XCTAssertEqual(last.category, .Pause, "")
        XCTAssertNil(last.finishedAt)
    }
    
    func testGetPauseLength() {
        let session = ThirdTimeSession()
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        session.segments.append(.init(category: .Focus, startedAt: thirtyMinAgo))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 600, accuracy: 0.001)
    }
    
    func testGetPauseLengthWithCustomBreaktimeFactor() {
        let session = ThirdTimeSession(breaktimeFactor: 5)
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        session.segments.append(.init(category: .Focus, startedAt: thirtyMinAgo))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 360, accuracy: 0.001)
    }
    
    func testSessionWithMultipleEntries() {
        let session = ThirdTimeSession()
        
        let thirtyMinSession = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        session.segments.append(.init(category: .Focus, startedAt: thirtyMinSession))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 600, accuracy: 0.001)
        
        let _ = session.segments.popLast()
        let fifteenMinSession = Calendar.current.date(byAdding: .minute, value: -15, to: .now)!
        session.segments.append(.init(category: .Pause, startedAt: fifteenMinSession))
        session.next()
        
        XCTAssertEqual(session.availableBreak, -300, accuracy: 0.001)
        
        let _ = session.segments.popLast()
        let OneHourSession = Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
        session.segments.append(.init(category: .Focus, startedAt: OneHourSession))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 900, accuracy: 0.001)
    }
    
    func testSessionWithBreakLimit() {
        let session = ThirdTimeSession(breaktimeLimit: 300)
        let thirtyMinAgo = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        session.segments.append(.init(category: .Focus, startedAt: thirtyMinAgo))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 300, accuracy: 0.001)
    }
    
    func testSessionWithBreakLimitAndMultipleEntries() {
        let session = ThirdTimeSession(breaktimeLimit: 300)
        
        let thirtyMinSession = Calendar.current.date(byAdding: .minute, value: -30, to: .now)!
        session.segments.append(.init(category: .Focus, startedAt: thirtyMinSession))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 300, accuracy: 0.001)
        
        let _ = session.segments.popLast()
        let fifteenMinSession = Calendar.current.date(byAdding: .minute, value: -15, to: .now)!
        session.segments.append(.init(category: .Pause, startedAt: fifteenMinSession))
        session.next()
        
        XCTAssertEqual(session.availableBreak, -600, accuracy: 0.001)
        
        let _ = session.segments.popLast()
        let OneHourSession = Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
        session.segments.append(.init(category: .Focus, startedAt: OneHourSession))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 300, accuracy: 0.001)
        
        let _ = session.segments.popLast()
        let threeMinSession = Calendar.current.date(byAdding: .minute, value: -3, to: .now)!
        session.segments.append(.init(category: .Pause, startedAt: threeMinSession))
        session.next()
        
        XCTAssertEqual(session.availableBreak, 120, accuracy: 0.001)
    }
    
    func testGetCurrentSegment() {
        let session = ThirdTimeSession()
        
        // No current session
        XCTAssertNil(session.getCurrent())
        
        
        session.next()
        XCTAssertEqual(session.segments.last, session.getCurrent())
        
        session.next()
        XCTAssertEqual(session.segments.last, session.getCurrent())
    }
    
    func testEndSession() {
        let session = ThirdTimeSession()
        session.next()
        
        XCTAssertEqual(session.segments.count, 1)
        XCTAssertTrue(session.getCurrent()!.isRunning)
        
        session.endSession()
        
        XCTAssertEqual(session.segments.count, 1)
        XCTAssertFalse(session.getCurrent()!.isRunning)
    }
}
