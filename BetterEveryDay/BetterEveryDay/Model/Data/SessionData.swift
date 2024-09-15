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
    var state: SessionState.RawValue
    var goal: String
    var started: Date
    var breaktimeLimit: Int
    var breaktimeFactor: Double
    var availableBreak: TimeInterval
    var duration: TimeInterval
    var timeSpendWork: TimeInterval
    var timeSpendPause: TimeInterval
    
    @Relationship(deleteRule: .cascade, inverse: \SessionSegmentData.session) var segments: [SessionSegmentData]
    
    init(state: SessionState.RawValue,
         goal: String,
         started: Date,
         breaktimeLimit: Int,
         breaktimeFactor: Double,
         availableBreak: TimeInterval,
         duration: TimeInterval,
         timeSpendWork: TimeInterval,
         timeSpendPause: TimeInterval,
         segments: [SessionSegmentData]) {
        self.state = state
        self.goal = goal
        self.started = started
        self.breaktimeLimit = breaktimeLimit
        self.breaktimeFactor = breaktimeFactor
        self.availableBreak = availableBreak
        self.duration = duration
        self.timeSpendWork = timeSpendWork
        self.timeSpendPause = timeSpendPause
        self.segments = segments
    }
}

@Model final class SessionSegmentData {
    var session: SessionData?
    var category: SessionCategory.RawValue
    var startedAt: Date
    var finishedAt: Date?
    var duration: Double
    
    init(category: SessionCategory.RawValue, startedAt: Date, finishedAt: Date? = nil, duration: Double) {
        self.session = nil
        self.category = category
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.duration = duration
    }
}

