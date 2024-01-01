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
        print("____ Available Breaktime \(total.focus / 3 - total.break)")
        return total.focus / 3 - total.break
    }
    
    init(goal: String, history: [PhaseMarker], started: Date) {
        self.state = .RUNNING
        self.goal = goal
        self.history = history
        self.started = started
    }
    
    init() {
        self.init(goal: "", history: [], started: .now)
    }
}
