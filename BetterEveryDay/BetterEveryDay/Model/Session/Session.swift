//
//  SessionSections.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.08.24.
//

import Foundation


/// Session is the session control element. It contains the different  ``SessionSegment``objects, which make up the session.
@Observable final class Session {
    var segments: [SessionSegment] = []
    var availableBreak: TimeInterval
    var breaktimeLimit = 0
    
    init(segments: [SessionSegment] = [],
         availableBreak: TimeInterval = 0,
         breaktimeLimit: Int = 0) {
        
        self.segments = segments
        self.availableBreak = availableBreak
        self.breaktimeLimit = breaktimeLimit
    }
    
    /// Finish up the current  ``SessionSegment``, update availableBreak and create new SessionSegment
    func next() {
        guard var last = segments.popLast() else {
            createNew(category: .Focus)
            return
        }
        finishSection(&last)
        updateBreak(last)
        
        let nextCategory: SessionCategory = if last.category == .Focus { .Pause } else { .Focus }
        createNew(category: nextCategory)
    }
    
    /// Get the current ``SessionSegment``
    func getCurrent() -> SessionSegment? {
        segments.last
    }
    
    /// End the currently running session
    func endSession() {
        guard var last = segments.popLast() else { return }
        finishSection(&last)
    }
    
    private func finishSection(_ section: inout SessionSegment) {
        section.finishedAt = Date.now
        segments.append(section)
    }
    
    private func updateBreak(_ segment: SessionSegment) {
        let limit = breaktimeLimit > 0 ? breaktimeLimit : .max
        let newBreaktime = calculateBreak(segment) + availableBreak
        
        availableBreak = min(newBreaktime, TimeInterval(limit))
    }
    
    private func calculateBreak(_ segment: SessionSegment) -> TimeInterval {
        switch segment.category {
        case .Focus:
            segment.duration / 3
        case .Pause:
            -segment.duration
        }
    }
    
    private func createNew(category: SessionCategory) {
        segments.append(.init(category: category))
    }
}


/// Describes on part of a session
struct SessionSegment: Equatable {
    let category: SessionCategory
    let startedAt: Date
    var finishedAt: Date?
    
    init(category: SessionCategory, startedAt: Date = .now, finishedAt: Date? = nil) {
        self.category = category
        self.startedAt = startedAt
        self.finishedAt = finishedAt
    }
    
    /// Computed duration value: time from start to finish
    var duration: TimeInterval {
        guard let finishedAt else { return Date.now.timeIntervalSince1970 - startedAt.timeIntervalSince1970 }
        
        return finishedAt.timeIntervalSince1970 - startedAt.timeIntervalSince1970
    }
    
    /// True if SessionSegment has no finishedAt value
    var isRunning: Bool { finishedAt == nil }
}
