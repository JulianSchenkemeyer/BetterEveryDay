//
//  SessionSnapshot.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 22.04.25.
//
import Foundation

protocol SessionDataProperties {
    var type: SessionType.RawValue { get set }
    var state: SessionState.RawValue { get set }
    var goal: String { get set }
    var started: Date { get set }
    var focusTimeLimit: Int { get set }
    var breaktimeLimit: Int { get set }
    var breaktimeFactor: Double { get set }
    var availableBreak: TimeInterval { get set }
    var duration: TimeInterval { get set }
    var timeSpendWork: TimeInterval { get set }
    var timeSpendPause: TimeInterval { get set }
}

protocol SessionSegmentOwner {
    associatedtype SegmentType
    var segments: [SegmentType] { get set }
}

protocol SessionModelProtocol: AnyObject, SessionDataProperties, SessionSegmentOwner
    where SegmentType == SessionSegmentData { }

protocol SessionSnapshotProtocol: SessionDataProperties, SessionSegmentOwner, Sendable
    where SegmentType == SessionSegmentSnapshot { }

extension SessionData: SessionModelProtocol, Convertible {
    var snapshot: SessionSnapshot {
        .init(
            id: id,
            type: type,
            state: state,
            goal: goal,
            started: started,
            focusTimeLimit: focusTimeLimit,
            breaktimeLimit: breaktimeLimit,
            breaktimeFactor: breaktimeFactor,
            availableBreak: availableBreak,
            duration: duration,
            timeSpendWork: timeSpendWork,
            timeSpendPause: timeSpendPause,
            segments: segments.map { $0.snapshot }
        )
    }
}

struct SessionSnapshot: SessionSnapshotProtocol, Identifiable {
    var id: ObjectIdentifier?
    
    var type: SessionType.RawValue
    var state: SessionState.RawValue
    var goal: String
    var started: Date
    var focusTimeLimit: Int
    var breaktimeLimit: Int
    var breaktimeFactor: Double
    var availableBreak: TimeInterval
    var duration: TimeInterval
    var timeSpendWork: TimeInterval
    var timeSpendPause: TimeInterval
    
    var segments: [SessionSegmentSnapshot]
}
