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
    func createNewSession(session: SessionProtocol, breakLimit: TimeInterval) async
    
    func finishRunningSession() async
    
    func update(session: SessionProtocol) async
    
    func getLatestRunningSession() async -> SessionProtocol?
    
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
    
    func createNewSession(session: SessionProtocol, breakLimit: TimeInterval) {
        let newSession = SessionData(type: session.type,
                                     state: session.state,
                                     goal: session.goal,
                                     started: session.started,
                                     phases: [],
                                     availableBreaktime: session.pauseBudget,
                                     breakLimit: breakLimit)
        
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
        currentSession.availableBreaktime = session.pauseBudget
    }
    
    func getLatestRunningSession() -> SessionProtocol? {
        let runningState = SessionState.RUNNING.rawValue
        let predicate = #Predicate<SessionData> { session in
            session.state == runningState
        }
        let sorting = [SortDescriptor<SessionData>(\.started, order: .reverse)]
        var fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sorting)
        fetchDescriptor.fetchLimit = 1
        
        do {
            let unfinishedSessions = try modelContainer.mainContext.fetch(fetchDescriptor)
            guard let unfinishedSession = unfinishedSessions.first else { return nil }
            
            let restoredSession = convert(session: unfinishedSession)
            currentSession = unfinishedSession
            
            return restoredSession
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func get() {
        
    }

    func convert(session: SessionData) -> SessionProtocol {
        let type = SessionType(rawValue: session.type)!
        let goal = session.goal
//        let state = SessionState(rawValue: session.state)
        let started = session.started
        
        let history = session.phases.map { phase in
            PhaseMarker(name: ThirdTimeState(rawValue: phase.type)!,
                        start: phase.started,
                        length: phase.length ?? 0)
        }
        
        switch type {
        case .limitless:
            print("convert to session without limit")
            
            return SessionWithoutLimit(goal: goal,
                                       history: history,
                                       started: started)
        case .withLimit:
            print("convert to session with limit")
            
            return SessionWithLimit(goal: goal,
                                    history: history,
                                    started: started,
                                    breaktime: session.availableBreaktime,
                                    breakLimit: 10)
        }
    }
}

