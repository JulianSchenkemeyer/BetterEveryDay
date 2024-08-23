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
    func createNewSession(from sessionController: SessionController)
    
    /// Finish the running session entry in the persistence layer, which sets the state of the entry to finished
    /// - Parameter sessionController: ``SessionController``  to be persisted
    func finishRunningSession(with sessionController: SessionController)
    
    /// Create a new SessionSegment linked to the currently running session in the persistence layer
    /// - Parameter segment: ``SessionSegment`` to be persisted
    func createNewSessionSegment(form segment: SessionSegment)
    
    /// Finish the current SessionSegment in the persistence layer through adding a finishedAt date
    func finishLastSessionSegment()
}

final class PersistenceManagerMock: PersistenceManagerProtocol {
    func createNewSession(from sessionController: SessionController) { }
    func finishRunningSession(with sessionController: SessionController) { }
    func createNewSessionSegment(form segment: SessionSegment) { }
    func finishLastSessionSegment() { }
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
    
    @MainActor func createNewSession(from sessionController: SessionController) {
        let session = sessionController.session
        
        let newSessionData = SessionData(state: sessionController.state.rawValue,
                                         goal: sessionController.goal,
                                         started: .now,
                                         breaktimeLimit: session.breaktimeLimit,
                                         breaktimeFactor: session.breaktimeFactor,
                                         availableBreak: session.availableBreak,
                                         segments: [])
        currentSession = newSessionData
        
        modelContainer.mainContext.insert(newSessionData)
    }
    
    func finishRunningSession(with sessionController: SessionController) {
        guard let currentSession else {
            print("❌ no current session")
            return
        }
        let session = sessionController.session
        
        currentSession.state = "Finished"
        currentSession.availableBreak = session.availableBreak
    }
    
    func createNewSessionSegment(form segment: SessionSegment) {
        
    }
    
    func finishLastSessionSegment() {
        
    }
}
