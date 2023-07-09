//
//  ThirdTimeViewModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 09.07.23.
//

import SwiftUI

struct PhaseTimer {
    let start: Date
    let displayStart: Date
    
    var length: TimeInterval {
        Date.now.timeIntervalSince1970 - start.timeIntervalSince1970
    }
    
    init(displayStart: Date) {
        self.displayStart = displayStart
        self.start = Date.now
    }
    
    init(add timeInterval: TimeInterval) {
        let now = Date.now
        let modifiedDate = now.timeIntervalSince1970 + timeInterval
        
        self.displayStart = Date(timeIntervalSince1970: modifiedDate)
        self.start = now
    }
}

struct PhaseMarker {
    let start: Date
    let length: TimeInterval
    
    init(_ phaseTimer: PhaseTimer) {
        self.start = phaseTimer.start
        self.length = phaseTimer.length
    }
}

final class ThirdTimeViewModel: ObservableObject {
    
    var phaseTimer: PhaseTimer?
    var focusPhaseHistory: [PhaseMarker] = []
    var pausePhaseHistory: [PhaseMarker] = []

    
    @Published var phase: ThirdTimeState {
        didSet {
            switch phase {
            case .Prepare:
                phaseTimer = nil
                focusPhaseHistory = []
                pausePhaseHistory = []
            case .Focus:
                appendPreviousPhaseTo(&pausePhaseHistory)
                
                phaseTimer = PhaseTimer(displayStart: Date.now)
             
            case .Pause:
                appendPreviousPhaseTo(&focusPhaseHistory)
                
                let availableBreakTime = calculateBreakTime()
                phaseTimer = PhaseTimer(add: availableBreakTime)
                
            case .Reflect:
                break
//                totalBreakLength = 0.0
//                totalFocusLength = 0.0
            }
        }
    }
    
    init(phase: ThirdTimeState = .Prepare) {
        self.phase = phase
        switch phase {
        case .Prepare, .Reflect:
            break
        case .Focus, .Pause:
            phaseTimer = PhaseTimer(displayStart: Date.now)
        }
    }
    
    private func appendPreviousPhaseTo(_ history: inout [PhaseMarker]) {
        if let previousTimer = phaseTimer {
            let marker = PhaseMarker(previousTimer)
            history.append(marker)
        }
    }
    
    private func calculateBreakTime() -> TimeInterval {
        guard let lastFocusPhase = focusPhaseHistory.last else {
            return 0
        }
        
        return lastFocusPhase.length / 3
    }

    
//    private func calculateAvailableBreakTime() -> TimeInterval {
//        guard let startOfLastFocusSession else { return 0.0 }
//
//        let lengthOfLastFocusSession = Date.now.timeIntervalSince1970 - startOfLastFocusSession.timeIntervalSince1970
//
//        return ceil(lengthOfLastFocusSession / 3)
//    }
//
//    private func setBreakTimer() -> Date {
//        let modifiedStartDate = Date.now.timeIntervalSince1970 + availableBreakTime
//        return Date(timeIntervalSince1970: modifiedStartDate)
//    }
//
//    private func calculateTimeProgressed() -> TimeInterval {
//        Date.now.timeIntervalSince1970 - timerStart.timeIntervalSince1970
//    }
//
//    private func continuePreviousTimer(with offset: Double) -> Date {
//        let modifiedStartDate = Date.now.timeIntervalSince1970 - offset
//        print("continue from \(modifiedStartDate)")
//
//        return Date(timeIntervalSince1970: modifiedStartDate)
//    }
//
//    private func calculateMaxBreakTime() {
//
//    }
}
