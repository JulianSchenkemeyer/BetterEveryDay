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
