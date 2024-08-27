//
//  PersistenceManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.12.23.
//

import Foundation
import SwiftData

/// Defines the functions needed to persist the session
protocol PersistenceManagerProtocol: ObservableObject {
    /// Create a new session entry in the persistence layer
    /// - Parameter sessionController: ``SessionController``  to be persisted
    func insertSession(from sessionController: SessionController)
    
    /// Update an existing session entry in the persistence layer
    /// - Parameter session: ``Session`` to be persisted
    func updateSession(with session: Session)
    
    /// Finish the running session entry in the persistence layer, which sets the state of the entry to finished
    /// - Parameter session: ``Session``  to be persisted
    func finishSession(with session: Session)
}

final class PersistenceManagerMock: PersistenceManagerProtocol {
    func insertSession(from sessionController: SessionController) { }
    func updateSession(with session: Session) { }
    func finishSession(with session: Session) { }
}

final class SwiftDataPersistenceManager: PersistenceManagerProtocol {
    var currentSession: SessionData?
    var modelContainer: ModelContainer
    
    init() {
        self.modelContainer = {
            let schema = Schema([SessionData.self])
            let container = try! ModelContainer(for: schema, configurations: [])
            return container
        }()
    }
    
    @MainActor func insertSession(from sessionController: SessionController) {
        let session = sessionController.session
        let sessionSegments = session.segments.map {
            SessionSegmentData(category: $0.category.rawValue,
                               startedAt: $0.startedAt,
                               finishedAt: $0.finishedAt)
        }
        
        let newSessionData = SessionData(state: sessionController.state.rawValue,
                                         goal: sessionController.goal,
                                         started: .now,
                                         breaktimeLimit: session.breaktimeLimit,
                                         breaktimeFactor: session.breaktimeFactor,
                                         availableBreak: session.availableBreak,
                                         segments: sessionSegments)
        currentSession = newSessionData
        
        modelContainer.mainContext.insert(newSessionData)
    }
    
    func updateSession(with session: Session) {
        guard let currentSession else {
            print("❌ no current session")
            return
        }
        
        guard let segment = session.segments.last else {
            print("❌ no segment to persist")
            return
        }
        
        currentSession.availableBreak = session.availableBreak
        currentSession.segments.append(.init(category: segment.category.rawValue,
                                             startedAt: segment.startedAt,
                                             finishedAt: segment.finishedAt))
    }
    
    func finishSession(with session: Session) {
        guard let currentSession else {
            print("❌ no current session")
            return
        }
        
        currentSession.state = "Finished"
        currentSession.availableBreak = session.availableBreak
    }
}
