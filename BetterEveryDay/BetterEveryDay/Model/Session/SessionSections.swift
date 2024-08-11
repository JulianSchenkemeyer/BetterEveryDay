//
//  SessionSections.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.08.24.
//

import Foundation


final class SessionSections {
    var sections: [SessionSection] = []
    var availableBreak: TimeInterval
    
    init(sections: [SessionSection] = [], availableBreak: TimeInterval = 0) {
        self.sections = sections
        self.availableBreak = availableBreak
    }
    
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
    
    private func finishSection(_ section: inout SessionSection) {
        section.finishedAt = Date.now
        sections.append(section)
    }
    
    private func updateBreak(_ section: SessionSection) -> TimeInterval {
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

struct SessionSection {
    let category: SessionCategory
    let startedAt: Date
    var finishedAt: Date?
    
    init(category: SessionCategory, startedAt: Date = .now, finishedAt: Date? = nil) {
        self.category = category
        self.startedAt = startedAt
        self.finishedAt = finishedAt
    }
    
    var duration: TimeInterval {
        guard let finishedAt else { return Date.now.timeIntervalSince1970 - startedAt.timeIntervalSince1970 }
        
        return finishedAt.timeIntervalSince1970 - startedAt.timeIntervalSince1970
    }
    
    var isRunning: Bool { finishedAt == nil }
}
