//
//  Mockdata.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 08.09.24.
//

import Foundation


struct Mockdata {
    nonisolated(unsafe) static let sessionData: SessionData = .init(type: "flexible",
                                                state: "Finished",
                                                goal: "mock entry",
                                                started: .now,
                                                focusTimeLimit: 0,
                                                breaktimeLimit: 3,
                                                breaktimeFactor: 3,
                                                availableBreak: 0,
                                                duration: 2000,
                                                timeSpendWork: 1500,
                                                timeSpendPause: 500,
                                                segments: [])
    
    nonisolated(unsafe) static var sessionSegments: [SessionSegment] {
                let now = Date()
                return [
                    SessionSegment(
                        category: .Focus,
                        startedAt: now.addingTimeInterval(-3600),   // 1h ago
                        finishedAt: now.addingTimeInterval(-1800)   // 30m ago
                    ),
                    SessionSegment(
                        category: .Pause,
                        startedAt: now.addingTimeInterval(-1800),   // 30m ago
                        finishedAt: now.addingTimeInterval(-1500)   // 25m ago
                    ),
                    SessionSegment(
                        category: .Focus,
                        startedAt: now.addingTimeInterval(-600),    // 10m ago
                        finishedAt: now.addingTimeInterval(-300)    // 5m ago
                    ),
                    SessionSegment(
                        category: .Pause,
                        startedAt: now.addingTimeInterval(-300),    // 5m ago
                    )
                ]
            }
                                                                      
    
    nonisolated(unsafe) static let sessionDataArray : [SessionData] = [.init(type: "flexible",
                                                         state: "Finished",
                                                         goal: "Work on Cell",
                                                         started: .now,
                                                         focusTimeLimit: 0,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 22000,
                                                         timeSpendWork: 18000,
                                                         timeSpendPause: 4000,
                                                         segments: []),
                                                   .init(type: "fixed",
                                                         state: "Finished",
                                                         goal: "Improve Cell design",
                                                         started: .now,
                                                         focusTimeLimit: 15,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 12000,
                                                         timeSpendWork: 9000,
                                                         timeSpendPause: 3000,
                                                         segments: []),
                                                   .init(type: "flexible",
                                                         state: "Finished",
                                                         goal: "Cleanup Code",
                                                         started: .now,
                                                         focusTimeLimit: 0,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 1500,
                                                         timeSpendWork: 1400,
                                                         timeSpendPause: 100,
                                                         segments: []),
                                                   .init(type: "flexible",
                                                         state: "Finished",
                                                         goal: "Organize Papers",
                                                         started: .now,
                                                         focusTimeLimit: 0,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 6000,
                                                         timeSpendWork: 2000,
                                                         timeSpendPause: 4000,
                                                         segments: []),
                                                   .init(type: "fixed",
                                                         state: "Finished",
                                                         goal: "Pack Backpack",
                                                         started: .now,
                                                         focusTimeLimit: 30,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 500,
                                                         timeSpendWork: 500,
                                                         timeSpendPause: 0,
                                                         segments: []),]
}
