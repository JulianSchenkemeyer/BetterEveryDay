//
//  Session.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.12.23.
//

import Foundation
import SwiftData


@Model
final class SessionData {
    var type: SessionType
    var state: SessionState
    var goal: String
    var started: Date
    var phases: [PhaseData]
    var availableBreaktime: Double
    
    init(type: SessionType,
         state: SessionState,
         goal: String,
         started: Date,
         phases: [PhaseData],
         availableBreaktime: TimeInterval
    ) {
        self.type = type
        self.state = state
        self.goal = goal
        self.started = started
        self.phases = phases
        self.availableBreaktime = availableBreaktime
    }
}


enum SessionType: String, Codable {
    case withLimit = "with Limit"
    case limitless = "limitless"
    
    var description: String { self.rawValue }
}

@Model
final class PhaseData {
    var type: ThirdTimeState
    var started: Date
    var finished: Date?
    
    init(type: ThirdTimeState, started: Date, finished: Date? = nil) {
        self.type = type
        self.started = started
        self.finished = finished
    }
}
