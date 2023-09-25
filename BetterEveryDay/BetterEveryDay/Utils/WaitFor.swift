//
//  WaitFor.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 24.09.23.
//

import Foundation


func waitFor(seconds: TimeInterval) async throws {
    try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
}
