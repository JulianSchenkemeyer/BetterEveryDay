//
//  Mockdata.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 08.09.24.
//

import Foundation


struct Mockdata {
    static let sessionData: SessionData = .init(state: "Finished",
                                                goal: "mock entry",
                                                started: .now,
                                                breaktimeLimit: 3,
                                                breaktimeFactor: 3,
                                                availableBreak: 0,
                                                duration: 2000,
                                                timeSpendWork: 1500,
                                                timeSpendPause: 500,
                                                segments: [])
    
    static let sessionDataArray : [SessionData] = [.init(state: "Finished",
                                                         goal: "Work on Cell",
                                                         started: .now,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 22000,
                                                         timeSpendWork: 18000,
                                                         timeSpendPause: 4000,
                                                         segments: []),
                                                   .init(state: "Finished",
                                                         goal: "Improve Cell design",
                                                         started: .now,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 12000,
                                                         timeSpendWork: 9000,
                                                         timeSpendPause: 3000,
                                                         segments: []),
                                                   .init(state: "Finished",
                                                         goal: "Cleanup Code",
                                                         started: .now,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 1500,
                                                         timeSpendWork: 1400,
                                                         timeSpendPause: 100,
                                                         segments: []),
                                                   .init(state: "Finished",
                                                         goal: "Organize Papers",
                                                         started: .now,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 6000,
                                                         timeSpendWork: 2000,
                                                         timeSpendPause: 4000,
                                                         segments: []),
                                                   .init(state: "Finished",
                                                         goal: "Pack Backpack",
                                                         started: .now,
                                                         breaktimeLimit: 3,
                                                         breaktimeFactor: 3,
                                                         availableBreak: 0,
                                                         duration: 500,
                                                         timeSpendWork: 500,
                                                         timeSpendPause: 0,
                                                         segments: []),]
}
