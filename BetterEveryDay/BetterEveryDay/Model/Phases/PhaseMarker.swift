//
//  PhaseMarker.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 03.09.23.
//

import Foundation


struct PhaseMarker {
    let name: ThirdTimeState
    let start: Date
    let length: TimeInterval
    
    init(_ phaseTimer: PhaseTimerProtocol, phase: ThirdTimeState) {
        self.start = phaseTimer.start
        self.length = phaseTimer.length
        self.name = phase
    }
}
