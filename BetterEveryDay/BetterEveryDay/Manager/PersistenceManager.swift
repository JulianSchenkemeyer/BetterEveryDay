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
    
    func getLatestRunningSession() async
    
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
        currentSession.state = SessionState.FINISHED.rawValue
        
        self.currentSession = nil
    }
    
    func update(session: SessionProtocol) {
        guard let currentSession else { return }
        
        if session.history.count > currentSession.phases.count, let lastPhase = session.history.last {
            let phase = PhaseData(type: lastPhase.name, started: lastPhase.start, length: lastPhase.length)
            currentSession.phases.append(phase)
        }
        currentSession.availableBreaktime = session.availableBreakTime
    }
    
    func getLatestRunningSession() {
        let runningState = SessionState.RUNNING.rawValue
        let predicate = #Predicate<SessionData> { session in
            session.state == runningState
        }
        let sorting = [SortDescriptor<SessionData>(\.started, order: .reverse)]
        var fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sorting)
        fetchDescriptor.fetchLimit = 1
        
        do {
            let unfinishedSession = try modelContainer.mainContext.fetch(fetchDescriptor)
            print("fetched \(unfinishedSession.count) Sessions")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func get() {
        
    }
    
    
}

