//
//  Snaps.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 23.04.25.
//

protocol Convertible: AnyObject {
    associatedtype SnapshotType: Sendable

    var snapshot: SnapshotType { get }
}


