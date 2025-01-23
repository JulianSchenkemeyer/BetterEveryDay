//
//  ClassicSession.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.01.25.
//

import Foundation

enum SessionType: String {
    case fixed, flexible
}

struct SessionConfiguration {
    let type: SessionType
    
    let focustimeLimit: Int
    let breaktimeLimit: Int
    
    let breaktimeFactor: Double
}



/// Session with a fixed interval (focus and pause segment have a fixed length)
@Observable final class ClassicSession: SessionProtocol {
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
        
        let nextCategory: SessionCategory = if last.category == .Focus { .Pause } else { .Focus }
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
    
    private func createNew(category: SessionCategory) {
        let now = Date.now
        let timeToAdd = category == .Focus ? focustimeLimit : breaktimeLimit
        let finished = Calendar.current.date(byAdding: .minute, value: timeToAdd, to: now)!
        
        segments.append(SessionSegment(
            category: category,
            startedAt: now,
            finishedAt: finished
        ))
    }
    
    
//    /// Fill the segments array with the fixed session segments (focus, pause).
//    /// - Parameters:
//    ///   - segmentCount: Describes the amount of the segments which will be part of this session
//    ///   - lengthOfFocusSegments: Describes the duration of the focus segments
//    ///   - lengthOfPauseSegments: Describes the duration of the pause segments
//    private func contructSegmentsForSession(configuration: ClassicSessionConfiguration) {
//        let segmentCount = (configuration.focusSegmentCount * 2) - 1
//        let lengthOfFocusSegments = configuration.lengthOfFocusSegments
//        let lengthOfPauseSegments = configuration.lengthOfPauseSegments
//        
//        var previousSegmentFinishedAt = Date.now
//        
//        for i in 1..<segmentCount + 1 {
//            if i.isMultiple(of: 2) {
//                let finishedAt = previousSegmentFinishedAt + lengthOfPauseSegments
//                self.segments.append(
//                    .init(category: .Pause,
//                          startedAt: previousSegmentFinishedAt,
//                          finishedAt: finishedAt)
//                )
//                previousSegmentFinishedAt = finishedAt
//            } else {
//                let finishedAt = previousSegmentFinishedAt + lengthOfFocusSegments
//                self.segments.append(
//                    .init(category: .Focus,
//                          startedAt: previousSegmentFinishedAt,
//                          finishedAt: finishedAt)
//                )
//                previousSegmentFinishedAt = finishedAt
//            }
//        }
//    }
}
