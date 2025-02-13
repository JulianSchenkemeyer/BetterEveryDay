//
//  SessionSegmentData.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//
import Foundation
import SwiftData


@Model final class SessionSegmentData {
    var session: SessionData?
    var category: SegmentCategory.RawValue
    var startedAt: Date
    var finishedAt: Date?
    var duration: Double
    
    init(category: SegmentCategory.RawValue, startedAt: Date, finishedAt: Date? = nil, duration: Double) {
        self.session = nil
        self.category = category
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.duration = duration
    }
}
