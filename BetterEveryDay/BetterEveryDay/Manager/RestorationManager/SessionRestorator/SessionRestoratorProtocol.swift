//
//  SessionRestoratorProtocol.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//
import Foundation


protocol SessionRestoratorProtocol {
    func restore(_ data: SessionData, onRestoredSegments: (([SessionSegment]) -> Void)?) -> RunningSessionData
}

extension SessionRestoratorProtocol {
    func restoreSegments(_ data: SessionData) -> [SessionSegment] {
        data.segments
            .map { SessionSegment(category: SegmentCategory(rawValue: $0.category)!, startedAt: $0.startedAt, finishedAt: $0.finishedAt) }
            .sorted(using: [KeyPathComparator(\.startedAt, order: .forward)])
    }
}
