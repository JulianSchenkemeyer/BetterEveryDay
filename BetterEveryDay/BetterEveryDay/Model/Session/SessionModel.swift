//
//  SessionModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.08.24.
//

import Foundation



@Observable class SessionModel {
    var state: SessionState
    var goal: String
    var started: Date
    
    var sections: SessionSections
    

    init(state: SessionState, goal: String, started: Date, sections: SessionSections = SessionSections()) {
        self.state = state
        self.goal = goal
        self.started = started
        self.sections = sections
    }
}


