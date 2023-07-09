//
//  ThirdTimeViewModelTests.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 09.07.23.
//

import XCTest
@testable import BetterEveryDay

final class ThirdTimeViewModelTests: XCTestCase {
    
    func testModelInit() {
        var prepare = ThirdTimeViewModel(phase: .Prepare)
        XCTAssertEqual(prepare.phase, .Prepare, "view model was not initialised in the prepare phase")
        XCTAssertNil(prepare.phaseTimer, "phaseTimer is not nil")
        
        var focus = ThirdTimeViewModel(phase: .Focus)
        XCTAssertEqual(focus.phase, .Focus, "view model was not initialised in the focus phase")
        XCTAssertNotNil(focus.phaseTimer, "phaseTimer is nil")
        
        var pause = ThirdTimeViewModel(phase: .Pause)
        XCTAssertEqual(pause.phase, .Pause, "view model was not initialised in the pause phase")
        XCTAssertNotNil(pause.phaseTimer, "phaseTimer is nil")
        
        var reflect = ThirdTimeViewModel(phase: .Reflect)
        XCTAssertEqual(reflect.phase, .Reflect, "view model was not initialised in the reflect phase")
    }
    
    func testSwitchFromPrepareToFocusSession() {
        var model = ThirdTimeViewModel()
        XCTAssertEqual(model.phase, .Prepare, "view model was not initialised in the prepare phase")
        XCTAssertNil(model.phaseTimer, "phaseTimer is not nil")
        
        model.phase = .Focus
        
        XCTAssertEqual(model.phase, .Focus, "view model was not switched to focus phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        XCTAssertEqual(model.focusPhaseHistory.count, 0)
        XCTAssertEqual(model.pausePhaseHistory.count, 0)
    }

    func testSwitchFromFocusToPauseSession() {
        var model = ThirdTimeViewModel(phase: .Focus)
        
        XCTAssertEqual(model.phase, .Focus, "view model was not initialised in the focus phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        XCTAssertEqual(model.focusPhaseHistory.count, 0)
        XCTAssertEqual(model.pausePhaseHistory.count, 0)
        
        model.phase = .Pause
        
        XCTAssertEqual(model.phase, .Pause, "view model was not switched to pause phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        XCTAssertEqual(model.focusPhaseHistory.count, 1)
        XCTAssertEqual(model.pausePhaseHistory.count, 0)
    }
    
    func testSwitchFromPauseToFocusSession() {
        var model = ThirdTimeViewModel(phase: .Pause)
        
        XCTAssertEqual(model.phase, .Pause, "view model was not initialised in the pause phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        XCTAssertEqual(model.focusPhaseHistory.count, 0)
        XCTAssertEqual(model.pausePhaseHistory.count, 0)
        
        model.phase = .Focus
        
        XCTAssertEqual(model.phase, .Focus, "view model was not switched to focus phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        XCTAssertEqual(model.focusPhaseHistory.count, 0)
        XCTAssertEqual(model.pausePhaseHistory.count, 1)
    }
    
    func testSwitchFromFocusToReflectSession() {
        var model = ThirdTimeViewModel(phase: .Focus)
        
        XCTAssertEqual(model.phase, .Focus, "view model was not initialised in the focus phase")
        
        model.phase = .Reflect
        
        XCTAssertEqual(model.phase, .Reflect, "view model was not switched to reflect phase")
    }
    
    func testSwitchFromPauseToReflectSession() {
        var model = ThirdTimeViewModel(phase: .Pause)
        
        XCTAssertEqual(model.phase, .Pause, "view model was not initialised in the pause phase")
        
        model.phase = .Reflect
        
        XCTAssertEqual(model.phase, .Reflect, "view model was not switched to reflect phase")
    }
    
    func testSwitchFromReflectToPrepareSession() {
        var model = ThirdTimeViewModel(phase: .Reflect)
        
        XCTAssertEqual(model.phase, .Reflect, "view model was not initialised in the reflect phase")
        
        model.phase = .Prepare
        
        XCTAssertEqual(model.phase, .Prepare, "view model was not switched to prepare phase")
    }
}
