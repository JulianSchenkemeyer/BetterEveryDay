//
//  SessionWithLimit.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.09.23.
//

import Foundation


final class BreaktimeTracker {
    private (set) var breaktime: TimeInterval
    private let limit: TimeInterval
    
    init(breaktime: TimeInterval, limit: TimeInterval) {
        self.breaktime = breaktime
        self.limit = limit
    }
    
    func increaseBreaktime(by sessionLength: TimeInterval) {
        breaktime = min(breaktime + sessionLength, limit)
    }
    
    func decreaseBreaktime(by sessionLength: TimeInterval) { 
        breaktime = breaktime - sessionLength
    }
}

struct SessionWithLimit: SessionProtocol {
    let type: SessionType = .withLimit
    var goal: String = ""
    var state: SessionState
    var history: [PhaseMarker] {
        didSet {
            guard let lastSession = history.last else { return }
            
            switch lastSession.name {
            case .Focus:
                let length = lastSession.length / 3
                tracker.increaseBreaktime(by: length)
            case .Pause:
                tracker.decreaseBreaktime(by: lastSession.length)
            default:
                tracker.increaseBreaktime(by: 0)
            }
        }
    }
    var started: Date
    
    let breakLimit: TimeInterval
    var tracker: BreaktimeTracker
    
    var pauseBudget: TimeInterval {
        return tracker.breaktime
    }
    
    
    init(goal: String, history: [PhaseMarker], started: Date, breaktime: TimeInterval,breakLimit: TimeInterval) {
        self.goal = goal
        self.state = .RUNNING
        self.history = history
        self.started = started
        self.breakLimit = breakLimit
        
        self.tracker = BreaktimeTracker(breaktime: breaktime, limit: breakLimit)
    }
    
    init(breakLimit: TimeInterval) {
        self.init(goal: "", history: [], started: .now, breaktime: 0, breakLimit: breakLimit)
    }
}
