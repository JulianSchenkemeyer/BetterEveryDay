//
//  Session.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 03.09.23.
//

import Foundation


enum SessionState {
    case RUNNING, FINISHED
}

struct Session {
    private var state: SessionState
    private var history: [PhaseMarker]
    private var started: Date
    
    var total: (focus: TimeInterval, break: TimeInterval) {
        return history.reduce(into: (focus: 0.0, break: 0.0)) { partialResult, phase in
            if phase.name == .Focus {
                partialResult.focus += phase.length
            } else if phase.name == .Pause {
                partialResult.break += phase.length
            }
        }
    }
    
    var length: TimeInterval {
        return history.reduce(into: 0.0) { (partialResult, phase) in
            partialResult += phase.length
        }
    }
    
    var availableBreaktime: TimeInterval {
        total.focus / 3 - total.break
    }
    
    mutating func setToFinish() {
        state = .FINISHED
    }
    
    mutating func append(phase: PhaseMarker) {
        history.append(phase)
    }
    
    init() {
        state = .RUNNING
        history = []
        started = .now
    }
}
