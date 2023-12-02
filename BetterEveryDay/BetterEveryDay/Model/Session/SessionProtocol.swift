//
//  SessionProtocol.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.09.23.
//

import Foundation


protocol SessionProtocol {
    var type: SessionType { get }
    var goal: String { get }
    var state: SessionState { get set }
    var history: [PhaseMarker] { get set }
    var started: Date { get }
    
    var availableBreakTime: TimeInterval { get }
}

extension SessionProtocol {
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
    
    mutating func setToFinish() {
        state = .FINISHED
    }
    
    mutating func append(phase: PhaseMarker) {
        history.append(phase)
    }
}
