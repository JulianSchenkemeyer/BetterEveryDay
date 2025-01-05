//
//  ClassicSession.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.01.25.
//

import Foundation

@Observable final class ClassicSession: SessionProtocol {
    var segments: [SessionSegment] = []
    var availableBreak: TimeInterval = 0
    
    func getCurrent() -> SessionSegment? {
        return segments.last
    }
    
    func next(onFinishingSegment: OnFinishingSegmentClosure) {
        
    }
    
    func endSession(onFinishingSegment: OnFinishingSegmentClosure) {
        
    }
}
