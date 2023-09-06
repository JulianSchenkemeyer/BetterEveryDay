//
//  SessionWithLimit.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.09.23.
//

import Foundation


struct SessionWithLimit: SessionProtocol {
    var state: SessionState
    var history: [PhaseMarker]
    var started: Date
    
    let breakLimit: TimeInterval
    
    var availableBreakTime: TimeInterval {
        return min(total.focus / 3 - total.break, breakLimit)
    }
    
    init(breakLimit: TimeInterval) {
        self.state = .RUNNING
        self.history = []
        self.started = .now
        self.breakLimit = breakLimit
    }
}
