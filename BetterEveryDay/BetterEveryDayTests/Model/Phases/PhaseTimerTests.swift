//
//  PhaseTimerTest.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 06.09.23.
//

import XCTest
@testable import BetterEveryDay

final class PhaseTimerTest: XCTestCase {

    func testCreatePhaseTimer() {
        let now = Date.now
        let phaseTimer = PhaseTimer(displayStart: now)
        
        
        XCTAssertEqual(phaseTimer.displayStart,
                       now,
                       "PhaseTimer.displayStart value does not match its initial value")
        XCTAssertEqual(phaseTimer.start.timeIntervalSinceReferenceDate,
                       now.timeIntervalSinceReferenceDate,
                       accuracy: 0.001)
        XCTAssert(phaseTimer.length > 0, "PhaseTimer did not capture the difference between now and its creation")
    }
    
    func testCreatePhaseTimerWithOffset() {
        let twoMinutesInTheFuture = Calendar.current.date(byAdding: .minute, value: 2, to: .now)!
        let phaseTimer = PhaseTimer(add: 120.0)
        let now = Date.now
        
        
        XCTAssertEqual(phaseTimer.displayStart.timeIntervalSinceReferenceDate,
                       twoMinutesInTheFuture.timeIntervalSinceReferenceDate,
                       accuracy: 0.001,
                       "PhaseTimer.displayStart value does not match its initial value")
        XCTAssertEqual(phaseTimer.start.timeIntervalSinceReferenceDate,
                       now.timeIntervalSinceReferenceDate,
                       accuracy: 0.001)
        XCTAssert(phaseTimer.length > 0, "PhaseTimer did not capture the difference between now and its creation")
    }
}
