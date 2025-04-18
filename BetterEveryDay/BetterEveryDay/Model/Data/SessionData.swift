//
//  Session.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.12.23.
//

import Foundation
import SwiftData


@Model final class SessionData {
    var type: SessionType.RawValue
    var state: SessionState.RawValue
    var goal: String
    var started: Date
    var focusTimeLimit: Int
    var breaktimeLimit: Int
    var breaktimeFactor: Double
    var availableBreak: TimeInterval
    var duration: TimeInterval
    var timeSpendWork: TimeInterval
    var timeSpendPause: TimeInterval
    
    @Relationship(deleteRule: .cascade, inverse: \SessionSegmentData.session) var segments: [SessionSegmentData]
    
    init(type: SessionType.RawValue,
         state: SessionState.RawValue,
         goal: String,
         started: Date,
         focusTimeLimit: Int,
         breaktimeLimit: Int,
         breaktimeFactor: Double,
         availableBreak: TimeInterval,
         duration: TimeInterval,
         timeSpendWork: TimeInterval,
         timeSpendPause: TimeInterval,
         segments: [SessionSegmentData]) {
        self.type = type
        self.state = state
        self.goal = goal
        self.started = started
        self.focusTimeLimit = focusTimeLimit
        self.breaktimeLimit = breaktimeLimit
        self.breaktimeFactor = breaktimeFactor
        self.availableBreak = availableBreak
        self.duration = duration
        self.timeSpendWork = timeSpendWork
        self.timeSpendPause = timeSpendPause
        self.segments = segments
    }
}
