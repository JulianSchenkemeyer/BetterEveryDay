//
//  SessionSections.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.08.24.
//

import Foundation


/// Session is the session control element. It contains the different  ``SessionSegment``objects, which make up the session.
final class Session {
    var sections: [SessionSegment] = []
    var availableBreak: TimeInterval
    
    init(sections: [SessionSegment] = [], availableBreak: TimeInterval = 0) {
        self.sections = sections
        self.availableBreak = availableBreak
    }
    
    /// Finish up the current  ``SessionSegment``, update availableBreak and create new SessionSegment
    func next() {
        guard var last = sections.popLast() else {
            createNew(category: .Focus)
            return
        }
        finishSection(&last)
        availableBreak += updateBreak(last)
        let nextCategory: SessionCategory = if last.category == .Focus { .Pause } else { .Focus }
        createNew(category: nextCategory)
    }
    
    private func finishSection(_ section: inout SessionSegment) {
        section.finishedAt = Date.now
        sections.append(section)
    }
    
    private func updateBreak(_ section: SessionSegment) -> TimeInterval {
        switch section.category {
        case .Focus:
            section.duration / 3
        case .Pause:
            -section.duration
        }
        
    }
    
    private func createNew(category: SessionCategory) {
        sections.append(.init(category: category))
    }
}


/// Describes on part of a session
struct SessionSegment {
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
