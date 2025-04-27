//
//  SessionSegmentSnapshot.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 22.04.25.
//
import Foundation

protocol SessionSegmentProtocol {
    var session: SessionData? { get set }
    var category: SegmentCategory.RawValue { get set }
    var startedAt: Date { get set }
    var finishedAt: Date? { get set }
    var duration: Double { get set }
}
protocol SessionSegmentSnapshotProtocol: SessionSegmentProtocol {}
protocol SessionSegmentModelProtocol: AnyObject, SessionSegmentProtocol {}


extension SessionSegmentData: SessionSegmentProtocol, Convertible {
    typealias SnapshotType = SessionSegmentSnapshot

    var snapshot: SessionSegmentSnapshot {
        .init(
            category: category,
            startedAt: startedAt,
            finishedAt: finishedAt,
            duration: duration
        )
    }
    
    func update(from snapshot: SessionSegmentSnapshot) {
        self.category = snapshot.category
        self.startedAt = snapshot.startedAt
        self.finishedAt = snapshot.finishedAt
        self.duration = snapshot.duration
    }
}

struct SessionSegmentSnapshot: SessionSegmentSnapshotProtocol {
    var session: SessionData?
    var category: SegmentCategory.RawValue
    var startedAt: Date
    var finishedAt: Date?
    var duration: Double
}
