//
//  PhaseTimer.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 03.09.23.
//

import Foundation


struct FocusPhaseTimer: PhaseProtocol {
    let start: Date
    
    var length: TimeInterval {
        Date.now.timeIntervalSince1970 - start.timeIntervalSince1970
    }
    
    init(start: Date) {
        self.start = start
    }
}
