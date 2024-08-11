//
//  SessionModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.08.24.
//

import Foundation



@Observable final class SessionController {
    var state: SessionState
    var goal: String
    var started: Date?
    
    var segments: Session
    

    init(state: SessionState = .RUNNING,
         goal: String = "",
         started: Date? = nil,
         sections: Session = Session()) {
        self.state = state
        self.goal = goal
        self.started = started
        self.segments = sections
    }
}


