//
//  FlexibleSessionRestorator.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//


/// SessionRestorator implementation for a ``FlexibleSession``
final class FlexibleSessionRestorator: SessionRestoratorProtocol {
    func restore(_ data: SessionSnapshot, onRestoredSegments: (@Sendable ([SessionSegment]) async -> Void)? = nil) -> RunningSessionData {
        var segments = restoreSegments(data)
        
        if let last = segments.last, let finishedAt = last.finishedAt {
            let category: SegmentCategory = last.category == SegmentCategory.Focus ? .Pause : .Focus
            segments.append(.init(category: category, startedAt: finishedAt))
        } else {
            // In case there is no session segment saved yet
            segments.append(.init(category: .Focus, startedAt: data.started))
        }
        
        let session = FlexibleSession(segments: segments, availableBreak: data.availableBreak, breaktimeLimit: data.breaktimeLimit, breaktimeFactor: data.breaktimeFactor)
        return (goal: data.goal,
                started: data.started,
                session: session,
                state: SessionState(rawValue: data.state)! )
    }
}
