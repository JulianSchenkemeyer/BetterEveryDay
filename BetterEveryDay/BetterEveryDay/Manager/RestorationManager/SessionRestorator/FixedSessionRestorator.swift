//
//  FixedSessionRestorator.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//
import Foundation


/// SessionRestorator implementation for a ``FixedSession``
final class FixedSessionRestorator: SessionRestoratorProtocol {
    func restore( _ data: SessionSnapshot, onRestoredSegments: (@Sendable ([SessionSegment]) async -> Void)? = nil) -> RunningSessionData {
        var segments = restoreSegments(data)
        
        // Restore running session in fixed session
        let now = Date.now
        var segmentStart = segments.last?.finishedAt ?? data.started
        
        // Keep track of segments, which are finished but are not persisted yet
        var untrackedSegments: [SessionSegment] = []
        while now > segmentStart {
            let category: SegmentCategory = if segments.last?.category == .Focus {
                .Pause
            } else {
                .Focus
            }
            let duration = category == .Focus ? data.focusTimeLimit : data.breaktimeLimit
            
            let finishedAt = Calendar.current.date(byAdding: .minute, value: duration, to: segmentStart)!
            let segment = SessionSegment(category: category, startedAt: segmentStart, finishedAt: finishedAt)
            segments.append(segment)
            
            if now > finishedAt {
                untrackedSegments.append(segment)
            }
            
            segmentStart = finishedAt
        }
        
        if let onRestoredSegments {
            Task {
                await onRestoredSegments(untrackedSegments)
            }
        }
        
        let session = FixedSession(segments: segments, focustimeLimit: data.focusTimeLimit, breaktimeLimit: data.breaktimeLimit)
        return (goal: data.goal,
                started: data.started,
                session: session,
                state: SessionState(rawValue: data.state)! )
    }
}
