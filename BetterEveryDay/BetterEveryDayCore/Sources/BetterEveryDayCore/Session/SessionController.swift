//
//  SessionModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.08.24.
//

import Foundation


/// SessionController contains information about the session aout to start or currently in preparation
@Observable public final class SessionController {
    public var state: SessionState
    public var goal: String
    public var started: Date?
    
    public var session: ThirdTimeSession
    

    
    /// Init SessionController
    /// - Parameters:
    ///   - state: ``SessionState``, defaults .PREPARING
    ///   - goal: String, describing the goal of the session, defaults ""
    ///   - started: Date, when the session started, nil if the session is not started yet; defaults nil
    ///   - session: ``ThirdTimeSession`` object containing the session data, defaults to an fresh instance
    public init(state: SessionState = .PREPARING,
         goal: String = "",
         started: Date? = nil,
         session: ThirdTimeSession = ThirdTimeSession()) {
        self.state = state
        self.goal = goal
        self.started = started
        self.session = session
    }
    
    
    /// Starts the session
    /// - Parameters:
    ///   - limit: Int, limit for the breaktime. 0 is limitless
    ///   - factor: Double, factor describing the rate breaktime is gained
    public func start(with limit: Int, factor: Double) {
        state = .RUNNING
        started = .now
        session = ThirdTimeSession(breaktimeLimit: limit, breaktimeFactor: factor)
    }
    
    /// Finish the current session
    public func finish() {
        state = .FINISHED
    }
    
    /// Reset the SessionController to its default values
    public func reset() {
        goal = ""
        started = nil
        state = .PREPARING
        session = ThirdTimeSession()
    }
    
    
    
    /// Configure the SessionController instance with values from a previous session
    /// - Parameters:
    ///   - state: ``SessionState``
    ///   - goal: String, describing the goal of the session
    ///   - started: Date, when the session started, nil if the session is not started yet
    ///   - session: ``ThirdTimeSession`` object containing the session data
    public func restore(state: SessionState, goal: String, started: Date?, session: ThirdTimeSession) {
        self.state = state
        self.goal = goal
        self.started = started
        self.session = session
    }
}

