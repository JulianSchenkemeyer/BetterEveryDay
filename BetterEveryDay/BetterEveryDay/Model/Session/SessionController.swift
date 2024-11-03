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
    
    var session: ThirdTimeSession
    

    init(state: SessionState = .PREPARING,
         goal: String = "",
         started: Date? = nil,
         sections: ThirdTimeSession = ThirdTimeSession()) {
        self.state = state
        self.goal = goal
        self.started = started
        self.session = sections
    }
    
    func start(with limit: Int, factor: Double) {
        state = .RUNNING
        started = .now
        session = ThirdTimeSession(breaktimeLimit: limit, breaktimeFactor: factor)
    }
    
    func finish() {
        state = .FINISHED
    }
    
    func reset() {
        goal = ""
        started = nil
        state = .PREPARING
        session = ThirdTimeSession()
    }
    
    func restore(goal: String, started: Date?, session: ThirdTimeSession, state: SessionState) {
        self.goal = goal
        self.started = started
        self.session = session
        self.state = state
    }
}


