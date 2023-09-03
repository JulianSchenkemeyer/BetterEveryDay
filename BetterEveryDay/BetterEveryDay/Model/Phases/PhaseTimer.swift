//
//  PhaseTimer.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 03.09.23.
//

import Foundation


struct PhaseTimer {
    let start: Date
    let displayStart: Date
    
    var length: TimeInterval {
        Date.now.timeIntervalSince1970 - start.timeIntervalSince1970
    }
    
    init(displayStart: Date) {
        self.displayStart = displayStart
        self.start = Date.now
    }
    
    init(add timeInterval: TimeInterval) {
        let now = Date.now
        let modifiedDate = now.timeIntervalSince1970 + timeInterval
        
        self.displayStart = Date(timeIntervalSince1970: modifiedDate)
        self.start = now
    }
}
