//
//  PhaseMarker.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 26.09.23.
//

import XCTest
@testable import BetterEveryDay

final class PhaseMarkerTests: XCTestCase {

    func testInit() throws {
        let now = Date.now
        let phaseTimer = FocusPhaseTimer(start: now)
        let phaseMarker = PhaseMarker(phaseTimer, phase: .Focus)
        
        
        XCTAssertEqual(phaseMarker.name, .Focus)
        XCTAssertEqual(phaseMarker.start, phaseTimer.start)
        XCTAssertEqual(phaseMarker.length, phaseTimer.length, accuracy: 0.001)
    }
}
