//
//  PhaseTimer.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 03.09.23.
//

import Foundation

protocol PhaseProtocol {
    var start: Date { get }
    
    var length: TimeInterval { get }
    
    init(start: Date)
}

struct FocusPhaseTimer: PhaseProtocol {
    let start: Date
    
    var length: TimeInterval {
        Date.now.timeIntervalSince1970 - start.timeIntervalSince1970
    }
    
    init(start: Date) {
        self.start = start
    }
}


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

