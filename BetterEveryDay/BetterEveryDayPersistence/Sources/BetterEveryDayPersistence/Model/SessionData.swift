//
//  Session.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.12.23.
//

import Foundation
import SwiftData
import BetterEveryDayCore


@Model
public final class SessionData {
    public var state: SessionState.RawValue
    public var goal: String
    public var started: Date
    public var breaktimeLimit: Int
    public var breaktimeFactor: Double
    public var availableBreak: TimeInterval
    public var duration: TimeInterval
    public var timeSpendWork: TimeInterval
    public var timeSpendPause: TimeInterval
    
    @Relationship(deleteRule: .cascade, inverse: \SessionSegmentData.session) public var segments: [SessionSegmentData]
    
    public init(state: SessionState.RawValue,
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

@Model public final class SessionSegmentData {
    public var session: SessionData?
    public var category: SessionCategory.RawValue
    public var startedAt: Date
    public var finishedAt: Date?
    public var duration: Double
    
    public init(category: SessionCategory.RawValue, startedAt: Date, finishedAt: Date? = nil, duration: Double) {
        self.session = nil
        self.category = category
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.duration = duration
    }
}

