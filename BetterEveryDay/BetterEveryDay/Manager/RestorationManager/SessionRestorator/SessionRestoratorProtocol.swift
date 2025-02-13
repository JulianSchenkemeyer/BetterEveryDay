//
//  SessionRestoratorProtocol.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//
import Foundation


/// Specifes methods needed for a SessionRestorator, which is used to restore the state of **running** Session based on its ``SessionData``
protocol SessionRestoratorProtocol {
    
    /// Restore a running session based on the provided SessionData
    /// - Parameters:
    ///   - data: ``SessionData`` describing the session to be restored
    ///   - onRestoredSegments: Optional closure, which can be used to process restored segments. Can be used for example
    ///   to persist currently untracked segments.
    /// - Returns: ``RunningSessionData``
    func restore(_ data: SessionData, onRestoredSegments: (([SessionSegment]) -> Void)?) -> RunningSessionData
}

extension SessionRestoratorProtocol {
    
    /// Method to restore segments from ``SessionData``. Default implementation provided through ``SessionRestoratorProtocol``
    /// - Parameter data: ``SessionData``
    /// - Returns: ``[SessionSegment]``
    func restoreSegments(_ data: SessionData) -> [SessionSegment] {
        data.segments
            .map { SessionSegment(category: SegmentCategory(rawValue: $0.category)!, startedAt: $0.startedAt, finishedAt: $0.finishedAt) }
            .sorted(using: [KeyPathComparator(\.startedAt, order: .forward)])
    }
}
