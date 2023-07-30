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
    
    var pauseIsLimited = false
    
    var phaseTimer: PhaseTimer?
    var availableBreakTime = 0.0
    var focusPhaseHistory: [PhaseMarker] = []
    var pausePhaseHistory: [PhaseMarker] = []
    var totalFocusTime = 0.0
    var totalBreakTime = 0.0

    
    @Published var phase: ThirdTimeState {
        willSet(newPhase) {
            // Finish previous phase
            appendPhaseToHistory()
            phaseTimer = nil
            
            if phase == .Focus && newPhase == .Pause {
                print("Focus -> Pause")
                availableBreakTime = addToBreakTime()
                print(availableBreakTime)
            }
            if phase == .Pause && newPhase == .Focus {
                print("Pause -> Focus")
                availableBreakTime = subtractFromBreakTime()
                print(availableBreakTime)
            }
        }
        didSet {
            // Setup new phase
            switch phase {
            case .Prepare:
                reset()
            case .Focus:
                phaseTimer = PhaseTimer(displayStart: Date.now)
             
            case .Pause:
                phaseTimer = PhaseTimer(add: availableBreakTime)
                
            case .Reflect:
                totalFocusTime = focusPhaseHistory.reduce(into: 0.0) { partialResult, phase in
                    partialResult = partialResult + phase.length
                }
                totalBreakTime = pausePhaseHistory.reduce(into: 0.0) { partialResult, phase in
                    partialResult = partialResult + phase.length
                }
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
    
    private func reset() {
        phaseTimer = nil
        focusPhaseHistory = []
        pausePhaseHistory = []
        totalBreakTime = 0.0
        totalFocusTime = 0.0
        availableBreakTime = 0.0
    }
    
    private func appendPhaseToHistory() {
        if phase == .Focus {
            appendPhaseTo(&focusPhaseHistory)
        } else if phase == .Pause {
            appendPhaseTo(&pausePhaseHistory)
        }
    }
    
    private func appendPhaseTo(_ history: inout [PhaseMarker]) {
        if let previousTimer = phaseTimer {
            let marker = PhaseMarker(previousTimer)
            history.append(marker)
        }
    }
    
    private func addToBreakTime() -> TimeInterval {
        guard let lastFocusPhase = focusPhaseHistory.last else {
            return 0
        }
        let updatedBreaktime = (lastFocusPhase.length / 3) + availableBreakTime
        
        if (pauseIsLimited) {
            return min(updatedBreaktime, 6)
        } else {
            return updatedBreaktime
        }
    }

    private func subtractFromBreakTime() -> TimeInterval {
        guard let lastPausePhase = pausePhaseHistory.last else {
            return 0
        }
        
        return availableBreakTime - lastPausePhase.length
    }
}