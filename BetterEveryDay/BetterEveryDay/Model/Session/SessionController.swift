//
//  SessionModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.08.24.
//

import Foundation


/// SessionController contains information about the session aout to start or currently in preparation
@Observable final class SessionController {
    var state: SessionState
    var goal: String
    var started: Date?
    
    var session: SessionProtocol
    

    
    /// Init SessionController
    /// - Parameters:
    ///   - state: ``SessionState``, defaults .PREPARING
    ///   - goal: String, describing the goal of the session, defaults ""
    ///   - started: Date, when the session started, nil if the session is not started yet; defaults nil
    ///   - session: ``ThirdTimeSession`` object containing the session data, defaults to an fresh instance
    init(state: SessionState = .PREPARING,
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
    ///   - sessionConfiguration: ``SessionConfiguration``, object containing the information needed to create a new Session
    func start(with sessionConfiguration: SessionConfiguration) {
        state = .RUNNING
        started = .now
        
        switch sessionConfiguration.type {
        case .flexible:
            session = ThirdTimeSession(breaktimeLimit: sessionConfiguration.breaktimeLimit, breaktimeFactor: sessionConfiguration.breaktimeFactor)
            
        case .fixed:
            session = ClassicSession(focustimeLimit: 25, breaktimeLimit: 5)
        }
    }
    
    /// Finish the current session
    func finish() {
        state = .FINISHED
    }
    
    /// Reset the SessionController to its default values
    func reset() {
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
    ///   - session: ``SessionProtocol`` object containing the session data
    func restore(state: SessionState, goal: String, started: Date?, session: SessionProtocol) {
        self.state = state
        self.goal = goal
        self.started = started
        self.session = session
    }
}


