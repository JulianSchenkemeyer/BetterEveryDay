//
//  ThirdTimeViewModelTests.swift
//  BetterEveryDayTests
//
//  Created by Julian Schenkemeyer on 09.07.23.
//

import XCTest
@testable import BetterEveryDay


@MainActor final class ThirdTimeViewModelTests: XCTestCase {
    
    func testModelInit() {
        let prepare = ThirdTimeViewModel(phase: .Prepare)
        XCTAssertEqual(prepare.phase, .Prepare, "view model was not initialised in the prepare phase")
        XCTAssertNil(prepare.phaseTimer, "phaseTimer is not nil")
        
        let focus = ThirdTimeViewModel(phase: .Focus)
        XCTAssertEqual(focus.phase, .Focus, "view model was not initialised in the focus phase")
        XCTAssertNotNil(focus.phaseTimer, "phaseTimer is nil")
        
        let pause = ThirdTimeViewModel(phase: .Pause)
        XCTAssertEqual(pause.phase, .Pause, "view model was not initialised in the pause phase")
        XCTAssertNotNil(pause.phaseTimer, "phaseTimer is nil")
        
        let reflect = ThirdTimeViewModel(phase: .Reflect)
        XCTAssertEqual(reflect.phase, .Reflect, "view model was not initialised in the reflect phase")
    }
    
    func testSwitchFromPrepareToFocusSession() {
        let model = ThirdTimeViewModel()
        XCTAssertEqual(model.phase, .Prepare, "view model was not initialised in the prepare phase")
        XCTAssertNil(model.phaseTimer, "phaseTimer is not nil")
        
        model.phase = .Focus
        
        XCTAssertEqual(model.phase, .Focus, "view model was not switched to focus phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        XCTAssertEqual(model.availableBreakTime, 0.0)
        XCTAssertEqual(model.session.history.count, 0)
    }

    func testSwitchFromFocusToPauseSession() {
        let model = ThirdTimeViewModel(phase: .Focus)
        validateInitialPhase(.Focus, for: model)
        
        model.phase = .Pause
        
        XCTAssertEqual(model.phase, .Pause, "view model was not switched to pause phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        // AvailableBreaktime increases
        XCTAssert(model.availableBreakTime > 0)
        XCTAssertEqual(model.session.history.count, 1)
    }
    
    func testSwitchFromPauseToFocusSession() {
        let model = ThirdTimeViewModel(phase: .Pause)
        validateInitialPhase(.Pause, for: model)

        
        model.phase = .Focus
        
        XCTAssertEqual(model.phase, .Focus, "view model was not switched to focus phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        // AvailableBreaktime decreases, because we start with pause and
        // go directly into overtime
        XCTAssert(model.availableBreakTime < 0)
        XCTAssertEqual(model.session.history.count, 1)
    }
    
    func testSwitchFromFocusToReflectSession() {
        let model = ThirdTimeViewModel(phase: .Focus)
        validateInitialPhase(.Focus, for: model)
        
        model.phase = .Reflect
        
        XCTAssertEqual(model.phase, .Reflect, "view model was not switched to reflect phase")
        XCTAssert(model.session.length > 0)
        XCTAssert(model.availableBreakTime == 0)
        XCTAssertEqual(model.session.history.count, 1)
        XCTAssertNil(model.phaseTimer, "remove phasetimer")
    }
    
    func testSwitchFromPauseToReflectSession() {
        let model = ThirdTimeViewModel(phase: .Pause)
        validateInitialPhase(.Pause, for: model)
        
        model.phase = .Reflect
        
        XCTAssertEqual(model.phase, .Reflect, "view model was not switched to reflect phase")
        XCTAssert(model.session.length > 0)
        XCTAssert(model.availableBreakTime < 0)
        XCTAssertEqual(model.session.history.count, 1)
        XCTAssertNil(model.phaseTimer, "remove phasetimer")
    }
    
    func testSwitchFromReflectToPrepareSession() {
        let model = ThirdTimeViewModel(phase: .Reflect)
//        validateInitialPhase(.Reflect, for: model)
        
        XCTAssertEqual(model.phase, .Reflect, "view model was not initialised in the reflect phase")
        
        model.phase = .Prepare
        
        XCTAssertEqual(model.phase, .Prepare, "view model was not switched to prepare phase")
    }
    
    //MARK: Helper
    private func validateInitialPhase(_ phase: ThirdTimeState, for model: ThirdTimeViewModel) {
        XCTAssertEqual(model.phase, phase, "view model was not initialised in the \(phase) phase")
        XCTAssertNotNil(model.phaseTimer, "phaseTimer is nil")
        XCTAssertEqual(model.availableBreakTime, 0.0)
        XCTAssertEqual(model.session.history.count, 0)
    }
}
