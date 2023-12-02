//
//  Session.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 03.09.23.
//

import Foundation


struct SessionWithoutLimit: SessionProtocol {
    var type: SessionType = .limitless
    var goal: String = ""
    var state: SessionState
    var history: [PhaseMarker]
    var started: Date
    
    var availableBreakTime: TimeInterval {
        return total.focus / 3 - total.break
    }
    
    init() {
        self.state = .RUNNING
        self.history = []
        self.started = .now
    }
}
