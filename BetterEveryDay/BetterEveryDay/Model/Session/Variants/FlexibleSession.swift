//
//  SessionSections.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.08.24.
//

import Foundation

/// ThirdTimeSession is the session control element. It contains the different  ``SessionSegment``objects, which make up the session.
@Observable final class FlexibleSession: SessionProtocol {
    let type: SessionType = .flexible
    var segments: [SessionSegment] = []
    var availableBreak: TimeInterval
    var breaktimeLimit = 0
    var breaktimeFactor = 3.0
    
    /// Initialise a new Session
    /// - Parameters:
    ///   - segments: ``SessionSegment`` array to prefill the session, default is empty
    ///   - availableBreak: Available breaktime for the session, default is 0
    ///   - breaktimeLimit: Limit for the available breaktime, default is unlimited (0)
    ///   - breaktimeFactor: Factor for calculating the available breaktime, default is 3
    init(segments: [SessionSegment] = [],
         availableBreak: TimeInterval = 0,
         breaktimeLimit: Int = 0,
         breaktimeFactor: Double = 3
    ) {
        self.segments = segments
        self.availableBreak = availableBreak
        self.breaktimeLimit = breaktimeLimit
        self.breaktimeFactor = breaktimeFactor
    }
    
    func getCurrent() -> SessionSegment? {
        segments.last
    }
    
    func next(onFinishingSegment: OnFinishingSegmentClosure = nil) {
        guard var last = segments.popLast() else {
            createNew(category: .Focus)
            return
        }
        finishSegment(&last)
        updateBreak(last)
        
        if let onFinishingSegment {
            onFinishingSegment(availableBreak, last)
        }
        
        let nextCategory: SegmentCategory = if last.category == .Focus { .Pause } else { .Focus }
        createNew(category: nextCategory)
    }
    
    func endSession(onFinishingSegment: OnFinishingSegmentClosure = nil) {
        guard var last = segments.popLast() else { return }
        updateBreak(last)
        finishSegment(&last)
        
        if let onFinishingSegment {
            onFinishingSegment(availableBreak, last)
        }
    }
    
    /// **Private** Finish the  given ``SessionSegment``
    /// - Parameter segment: the SessionSegment, which should be finished
    private func finishSegment(_ segment: inout SessionSegment) {
        segment.finishedAt = Date.now
        segments.append(segment)
    }
    
    /// **Private** update the available breaktime, based on the given ``SessionSegment``
    /// - Parameter segment: the SessionSegment, which will be used to update the breaktime
    private func updateBreak(_ segment: SessionSegment) {
        let limit = breaktimeLimit > 0 ? breaktimeLimit : .max
        let newBreaktime = calculateBreak(segment) + availableBreak
        
        availableBreak = min(newBreaktime, TimeInterval(limit))
    }
    
    /// **Private** Calculate the breaktime based on the ``SessionSegment``
    /// If the session was a Focus segment, its duration of the segment / breaktimeFactor.
    /// If the session was a Pause segment, its duration of the segment * (-1)
    /// - Parameter segment: the SessionSegment to calculate the breaktime
    /// - Returns: the new breaktime
    private func calculateBreak(_ segment: SessionSegment) -> TimeInterval {
        switch segment.category {
        case .Focus:
            segment.duration / breaktimeFactor
        case .Pause:
            -segment.duration
        }
    }
    
    /// **Private** Create a new ``SessionSegment``
    /// - Parameter category: the new ``SessionCategory`` for the new ``SessionSegment``
    private func createNew(category: SegmentCategory) {
        segments.append(.init(category: category))
    }
}
