//
//  ClassicSession.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.01.25.
//

import Foundation


/// Session with a fixed interval (focus and pause segment have a fixed length)
@Observable final class FixedSession: SessionProtocol {
    let type: SessionType = .fixed
    var segments: [SessionSegment] = []
    var availableBreak: TimeInterval = 0
    
    var focustimeLimit = 0
    var breaktimeLimit = 0
    
    
    init(segments: [SessionSegment] = [],
         focustimeLimit: Int = 0,
         breaktimeLimit: Int = 0
    ) {
        
        self.segments = segments
        self.focustimeLimit = focustimeLimit
        self.breaktimeLimit = breaktimeLimit
    }
    
    
    func getCurrent() -> SessionSegment? {
        segments.last
    }
    
    func next(onFinishingSegment: OnFinishingSegmentClosure = nil) {
        guard let last = getCurrent() else {
            createNew(category: .Focus)
            return
        }
        
        if let onFinishingSegment {
            onFinishingSegment(availableBreak, last)
        }
        
        let nextCategory: SegmentCategory = if last.category == .Focus { .Pause } else { .Focus }
        createNew(category: nextCategory)
    }
    
    func endSession(onFinishingSegment: OnFinishingSegmentClosure = nil) {
        guard var last = segments.popLast() else {
            return
        }
        
        last.finishedAt = .now
        segments.append(last)
        
        if let onFinishingSegment {
            onFinishingSegment(availableBreak, last)
        }
    }
    
    
    /// **Private** Create a new segment of the specified category
    /// - Parameter category: ``SegmentCategory`` of the new segment
    private func createNew(category: SegmentCategory) {
        let now = Date.now
        let timeToAdd = category == .Focus ? focustimeLimit : breaktimeLimit
        let finished = Calendar.current.date(byAdding: .minute, value: timeToAdd, to: now)!
        
        segments.append(SessionSegment(
            category: category,
            startedAt: now,
            finishedAt: finished
        ))
    }
}
