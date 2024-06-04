//
//  PausePhaseTimer.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.06.24.
//

import Foundation


struct PausePhaseTimer: PhaseProtocol {
    let start: Date
    let offset: Date
    
    var length: TimeInterval {
        Date.now.timeIntervalSince1970 - offset.timeIntervalSince1970
    }
    
    init(start: Date) {
        self.start = start
        self.offset = .now
    }
}
