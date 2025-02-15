//
//  SessionProtocol.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.01.25.
//

import Foundation

typealias OnFinishingSegmentClosure = ((TimeInterval, SessionSegment) -> Void)?


/// Defines the required properties and functions of a session
protocol SessionProtocol: Observable {
    
    /// Type of the session (Read-only)
    var type: SessionType { get }
    
    /// Stores the segments of the session
    var segments: [SessionSegment] { get set }
    
    /// Maximal time, which can be used for a break
    var availableBreak: TimeInterval { get set }
    
    
    /// Get the current session segment
    /// - Returns: either the current session segment or nil, if there is currently no segment
    func getCurrent() -> SessionSegment?
    
    
    /// Finish the current segment and create a new one
    /// - Parameter onFinishingSegment: closure allowing to process the finished segment further,
    ///      before the new segmen starts
    func next(onFinishingSegment: OnFinishingSegmentClosure)
    
    
    /// End the session through finishing the current segment
    /// - Parameter onFinishingSegment: closure allowing to process the finished segment further
    func endSession(onFinishingSegment: OnFinishingSegmentClosure)
    
}
