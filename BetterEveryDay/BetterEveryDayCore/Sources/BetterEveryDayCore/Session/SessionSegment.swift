//
//  SessionSegment.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.10.24.
//
import Foundation


/// Describes on part of a session
public struct SessionSegment: Equatable {
    public let category: SessionCategory
    public let startedAt: Date
    public var finishedAt: Date?
    
    public init(category: SessionCategory, startedAt: Date = .now, finishedAt: Date? = nil) {
        self.category = category
        self.startedAt = startedAt
        self.finishedAt = finishedAt
    }
    
    /// Computed duration value: time from start to finish
    public var duration: TimeInterval {
        guard let finishedAt else { return Date.now.timeIntervalSince1970 - startedAt.timeIntervalSince1970 }
        
        return finishedAt.timeIntervalSince1970 - startedAt.timeIntervalSince1970
    }
    
    /// True if SessionSegment has no finishedAt value
    public var isRunning: Bool { finishedAt == nil }
}
