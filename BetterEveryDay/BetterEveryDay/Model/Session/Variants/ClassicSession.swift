//
//  ClassicSession.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.01.25.
//

import Foundation

@Observable final class ClassicSession: SessionProtocol {
    var segments: [SessionSegment] = []
    var availableBreak: TimeInterval = 0
    private var activeSegmentIndex: Int = 0
    
    init(segments: [SessionSegment],
         availableBreak: TimeInterval = 0,
         activeSegmentIndex: Int = 0) {
        self.segments = segments
        self.availableBreak = availableBreak
        self.activeSegmentIndex = activeSegmentIndex
    }
    
    
    func getCurrent() -> SessionSegment? {
        if activeSegmentIndex >= segments.count {
            return nil
        }
        return segments[activeSegmentIndex]
    }
    
    func next(onFinishingSegment: OnFinishingSegmentClosure) {
        guard var last = getCurrent() else {
            return
        }
        
        last.finishedAt = Date.now
        
        if let onFinishingSegment {
            onFinishingSegment(0, last)
        }
        
        if activeSegmentIndex < segments.count {
            activeSegmentIndex += 1
        }
    }
    
    func endSession(onFinishingSegment: OnFinishingSegmentClosure) {
        guard var last = getCurrent() else {
            return
        }
        
        last.finishedAt = Date.now
        
        if let onFinishingSegment {
            onFinishingSegment(0, last)
        }
    }
}
