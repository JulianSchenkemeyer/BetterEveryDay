//
//  RestorationManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.02.25.
//
import Foundation


typealias RunningSessionData = (goal: String, started: Date, session: SessionProtocol, state: SessionState)

/// Protocol describing the methods needed to be impelemented by a RestorationManager, which oversees the restoration of a Session..
@MainActor protocol RestorationManagerProtocol {
    
    /// Transforms the given data into a tuple (``RunningSessionData``) containing the session data
    /// - Parameters:
    ///   - data: ``SessionData``  of the session, which is to be restored
    ///   - onRestoredSegments: Optional closure, which can be used to process restored segments. Can be used for example
    ///   to persist currently untracked segments.
    /// - Returns: Tuple containing the session data
    func restoreSessions(from data: SessionSnapshot, onRestoredSegments: (@Sendable ([SessionSegment]) async -> Void)?) async -> RunningSessionData
}

/// ``RestorationManagerProtocol`` implementation
@MainActor final class RestorationManager: RestorationManagerProtocol {
    private let factory = SessionRestoratorFactory()
    
    func restoreSessions(from data: SessionSnapshot, onRestoredSegments: (@Sendable ([SessionSegment]) async -> Void)? = nil) async -> RunningSessionData {
        let type = identifySessionType(data)
        let restorator = factory.createRestorator(for: type)
        
        return restorator.restore(data, onRestoredSegments: onRestoredSegments)
    }
    
    private func identifySessionType(_ data: SessionSnapshot) -> SessionType {
        SessionType(rawValue: data.type) ?? .flexible
    }
}
