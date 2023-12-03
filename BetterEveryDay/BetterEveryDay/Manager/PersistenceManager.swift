//
//  PersistenceManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.12.23.
//

import Foundation
import SwiftData

@MainActor
protocol PersistenceManagerProtocol {
    
    var currentSession: SessionData? { get set }
    
    func createNewSession(session: SessionProtocol) async
    
    func finishRunningSession() async
    
    func update(session: SessionProtocol) async
    
    func getLatest() async
    
    func get() async
}

@MainActor
final class SwiftDataPersistenceManager: PersistenceManagerProtocol, ObservableObject {
    var currentSession: SessionData?
    var modelContainer: ModelContainer
    
    init() {
        self.modelContainer = {
            let schema = Schema([SessionData.self])
            let container = try! ModelContainer(for: schema, configurations: [])
            return container
        }()
    }
    
    func createNewSession(session: SessionProtocol) {
        let newSession = SessionData(type: .limitless,
                                     state: session.state,
                                     goal: session.goal,
                                     started: session.started,
                                     phases: [],
                                     availableBreaktime: session.availableBreakTime)
        
        currentSession = newSession
        modelContainer.mainContext.insert(newSession)
    }
    
    func finishRunningSession() {
        guard let currentSession else { return }
        currentSession.state = .FINISHED
        
        self.currentSession = nil
    }
    
    func update(session: SessionProtocol) {
        guard let currentSession else { return }
        
        
    }
    
    func getLatest() {
        
    }
    
    func get() {
        
    }
    
    
}

