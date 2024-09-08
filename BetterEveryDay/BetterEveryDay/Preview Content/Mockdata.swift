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
                                             segments: [])
 
    static let sessionDataArray : [SessionData] = [.init(state: "Finished",
                                                  goal: "Work on Cell",
                                                  started: .now,
                                                  breaktimeLimit: 3,
                                                  breaktimeFactor: 3,
                                                  availableBreak: 0,
                                                  duration: 22000,
                                                  segments: []),
                                            .init(state: "Finished",
                                                   goal: "Improve Cell design",
                                                   started: .now,
                                                   breaktimeLimit: 3,
                                                   breaktimeFactor: 3,
                                                   availableBreak: 0,
                                                   duration: 12000,
                                                   segments: []),
                                            .init(state: "Finished",
                                                   goal: "Cleanup Code",
                                                   started: .now,
                                                   breaktimeLimit: 3,
                                                   breaktimeFactor: 3,
                                                   availableBreak: 0,
                                                   duration: 1500,
                                                   segments: []),
                                            .init(state: "Finished",
                                                   goal: "Organize Papers",
                                                   started: .now,
                                                   breaktimeLimit: 3,
                                                   breaktimeFactor: 3,
                                                   availableBreak: 0,
                                                   duration: 6000,
                                                   segments: []),
                                            .init(state: "Finished",
                                                   goal: "Pack Backpack",
                                                   started: .now,
                                                   breaktimeLimit: 3,
                                                   breaktimeFactor: 3,
                                                   availableBreak: 0,
                                                   duration: 500,
                                                   segments: []),]
}
