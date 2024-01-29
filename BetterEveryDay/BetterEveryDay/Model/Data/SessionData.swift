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
    var type: SessionType.RawValue
    var state: SessionState.RawValue
    var goal: String
    var started: Date
    var phases: [PhaseData]
    var breakLimit: TimeInterval
    var availableBreaktime: Double
    
    init(type: SessionType,
         state: SessionState,
         goal: String,
         started: Date,
         phases: [PhaseData],
         availableBreaktime: TimeInterval,
         breakLimit: TimeInterval
    ) {
        self.type = type.rawValue
        self.state = state.rawValue
        self.goal = goal
        self.started = started
        self.phases = phases
        self.availableBreaktime = availableBreaktime
        self.breakLimit = breakLimit
    }
}


enum SessionType: String, Codable {
    case withLimit = "with Limit"
    case limitless = "limitless"
    
    var description: String { self.rawValue }
}

@Model
final class PhaseData {
    var type: ThirdTimeState.RawValue
    var started: Date
    var length: TimeInterval?
    
    init(type: ThirdTimeState, started: Date, length: TimeInterval? = nil) {
        self.type = type.rawValue
        self.started = started
        self.length = length
    }
}
