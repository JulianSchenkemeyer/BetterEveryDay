////
////  SessionTests.swift
////  BetterEveryDayTests
////
////  Created by Julian Schenkemeyer on 26.09.23.
////
//
//import XCTest
//@testable import BetterEveryDay
//
//final class SessionTests: XCTestCase {
//
//    //MARK: SessionWithoutLimit
//    
//    func testCreateSessionWithoutLimit() throws {
//        let session = SessionFactory().createSession(with: 0)
//        validateSessionInitialisation(session)
//    }
//    
//    func testSessionWithoutLimitRunLoop() throws {
//        var session = SessionFactory().createSession(with: 0)
//        
//        let focusPhase = createPhaseMarker(length: 180, phase: .Focus)
//        session.append(phase: focusPhase)
//        validateSessionState(session, expected: (0, 180, 60))
//        
//        let pausePhase = createPhaseMarker(length: 60, phase: .Pause)
//        session.append(phase: pausePhase)
//        validateSessionState(session, expected: (60, 180, 0))
//        
//        let focusPhase2 = createPhaseMarker(length: 1800, phase: .Focus)
//        session.append(phase: focusPhase2)
//        validateSessionState(session, expected: (60, 1980, 600))
//        
//        let pausePhase2 = createPhaseMarker(length: 1200, phase: .Pause)
//        session.append(phase: pausePhase2)
//        validateSessionState(session, expected: (1260, 1980, -600))
//        
//        let focusPhase3 = createPhaseMarker(length: 3600, phase: .Focus)
//        session.append(phase: focusPhase3)
//        validateSessionState(session, expected: (1260, 5580, 600))
//    }
//    
//    //MARK: SessionWithLimit
//    
//    func testCreateSessionWithLimit() throws {
//        let session = SessionFactory().createSession(with: 120)
//        validateSessionInitialisation(session)
//    }
//    
//    func testSessionWithLimitRunLoop() throws {
//        var session = SessionFactory().createSession(with: 60)
//        
//        let focusPhase = createPhaseMarker(length: 60, phase: .Focus)
//        session.append(phase: focusPhase)
//        validateSessionState(session, expected: (0, 60, 20))
//        
//        let pausePhase = createPhaseMarker(length: 10, phase: .Pause)
//        session.append(phase: pausePhase)
//        validateSessionState(session, expected: (10, 60, 10))
//        
//        let focusPhase2 = createPhaseMarker(length: 180, phase: .Focus)
//        session.append(phase: focusPhase2)
//        validateSessionState(session, expected: (10, 240, 60))
//        
//        session.append(phase: pausePhase)
//        validateSessionState(session, expected: (20, 240, 50))
//        
//        session.append(phase: focusPhase2)
//        validateSessionState(session, expected: (20, 420, 60))
//    }
//    
//    func testSessionWithLimitRunLoopLimitExceeded() throws {
//        var session = SessionFactory().createSession(with: 120)
//        let focusPhase = createPhaseMarker(length: 1800, phase: .Focus)
//        session.append(phase: focusPhase)
//        validateSessionState(session, expected: (0, 1800, 120))
//        
//        
//        let pausePhase = createPhaseMarker(length: 60, phase: .Pause)
//        session.append(phase: pausePhase)
//        validateSessionState(session, expected: (60, 1800, 60))
//        
//        
//        session.append(phase: focusPhase)
//        validateSessionState(session, expected: (60, 3600, 120))
//        
//        
//        let pausePhase2 = createPhaseMarker(length: 180, phase: .Pause)
//        session.append(phase: pausePhase2)
//        validateSessionState(session, expected: (240, 3600, -60))
//
//        session.append(phase: focusPhase)
//        validateSessionState(session, expected: (240, 5400, 120))
//    }
//    
//    //MARK: Helper
//    
//    private func validateSessionInitialisation(_ session: SessionProtocol) {
//        XCTAssertEqual(session.state, .RUNNING)
//        XCTAssertEqual(session.history.count, 0)
//        XCTAssertEqual(session.started.timeIntervalSinceReferenceDate,
//                       Date.now.timeIntervalSinceReferenceDate,
//                       accuracy: 0.001)
//        
//        XCTAssertEqual(session.total.focus, 0)
//        XCTAssertEqual(session.total.break, 0)
//        XCTAssertEqual(session.length, 0)
//    }
//    
//    
//    typealias SessionState = (totalBreak: TimeInterval, totalFocus: TimeInterval, availableBreaktime: TimeInterval)
//    
//    private func validateSessionState(_ session: SessionProtocol, expected: SessionState) {
//        XCTAssertEqual(session.total.break,
//                       expected.totalBreak,
//                       accuracy: 0.001)
//        XCTAssertEqual(session.total.focus,
//                       expected.totalFocus,
//                       accuracy: 0.001)
//        XCTAssertEqual(session.availableBreakTime,
//                       expected.availableBreaktime,
//                       accuracy: 0.001)
//    }
//    
//    private func createPhaseMarker(length: TimeInterval, phase: ThirdTimeState) -> PhaseMarker {
//        let phaseTimer = PhaseTimerMock(fixedLength: length)
//        let phaseMarker = PhaseMarker(phaseTimer, phase: phase)
//        return phaseMarker
//    }
//    
//    private func timePassedSince(_ date: Date) -> TimeInterval {
//        if date < .now {
//            return -(date.timeIntervalSince1970 - Date.now.timeIntervalSince1970)
//        }
//        return Date.now.timeIntervalSince1970 - date.timeIntervalSince1970
//    }
//    
//    //MARK: Mocks
//    
//    struct PhaseTimerMock: PhaseTimerProtocol {
//        var start: Date
//        var displayStart: Date
//        var length: TimeInterval
//        
//        init(displayStart: Date) {
//            self.displayStart = displayStart
//            self.start = displayStart
//            self.length = Date.now.timeIntervalSince1970 - start.timeIntervalSince1970
//        }
//        
//        init(add timeInterval: TimeInterval) {
//            let now = Date.now
//            let modifiedDate = now.timeIntervalSince1970 + timeInterval
//            
//            self.displayStart = Date(timeIntervalSince1970: modifiedDate)
//            self.start = now
//            self.length = Date.now.timeIntervalSince1970 - start.timeIntervalSince1970
//        }
//        
//        init(fixedLength: TimeInterval) {
//            func dateMinus(minutes: Int) -> Date {
//                Calendar.current.date(byAdding: .minute, value: -minutes, to: .now)!
//            }
//            
//            self.length = fixedLength
//            let minutes = Int(fixedLength) / 60
//            let fixedDate = dateMinus(minutes: minutes)
//            self.start = fixedDate
//            self.displayStart = fixedDate
//        }
//    }
//}
