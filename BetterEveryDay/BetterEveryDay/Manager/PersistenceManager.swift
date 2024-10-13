//
//  PersistenceManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.12.23.
//

import Foundation
import SwiftData

/// Defines the functions needed to persist the session
protocol PersistenceManagerProtocol: Observable {
    /// Create a new session entry in the persistence layer
    /// - Parameter sessionController: ``SessionController``  to be persisted
    func insertSession(from sessionController: SessionController)
    
    /// Update an existing session entry in the persistence layer
    /// - Parameter session: ``Session`` to be persisted
    func updateSession(with session: Session)
    
    /// Finish the running session entry in the persistence layer, which sets the state of the entry to finished
    /// - Parameter session: ``Session``  to be persisted
    func finishSession(with session: Session)

    func getLatestRunningSession() -> SessionController?
    
    func getTodaysSessions() -> [SessionData]
}

final class PersistenceManagerMock: PersistenceManagerProtocol {
    func insertSession(from sessionController: SessionController) { }
    func updateSession(with session: Session) { }
    func finishSession(with session: Session) { }
    func getLatestRunningSession() -> SessionController? { nil }
    func getTodaysSessions() -> [SessionData] { Mockdata.sessionDataArray }
}

final class SwiftDataPersistenceManager: PersistenceManagerProtocol {
    var currentSession: SessionData?
    var modelContainer: ModelContainer
    
    init() {
        self.modelContainer = {
            let schema = Schema([SessionData.self])
            do {
                let container = try ModelContainer(for: schema, configurations: [])
                return container
            } catch {
                fatalError(error.localizedDescription)
            }
        }()
    }
    
    @MainActor func insertSession(from sessionController: SessionController) {
        let session = sessionController.session
        let sessionSegments = session.segments.map {
            SessionSegmentData(category: $0.category.rawValue,
                               startedAt: $0.startedAt,
                               finishedAt: $0.finishedAt,
                               duration: $0.duration
            )
        }
        let sessionDuration = sessionSegments.reduce(0.0) { $0 + $1.duration }
        
        let newSessionData = SessionData(state: sessionController.state.rawValue,
                                         goal: sessionController.goal,
                                         started: sessionController.started ?? .now,
                                         breaktimeLimit: session.breaktimeLimit,
                                         breaktimeFactor: session.breaktimeFactor,
                                         availableBreak: session.availableBreak,
                                         duration: sessionDuration,
                                         timeSpendWork: 0,
                                         timeSpendPause: 0,
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
        currentSession.duration += segment.duration
        
        switch segment.category {
        case .Focus:
            currentSession.timeSpendWork += segment.duration
        case .Pause:
            currentSession.timeSpendPause += segment.duration
        }
        
        currentSession.segments.append(.init(category: segment.category.rawValue,
                                             startedAt: segment.startedAt,
                                             finishedAt: segment.finishedAt,
                                             duration: segment.duration))
    }
    
    func finishSession(with session: Session) {
        guard let currentSession else {
            print("❌ no current session")
            return
        }
        
        currentSession.state = "Finished"
        currentSession.availableBreak = session.availableBreak
        currentSession.duration = session.segments.reduce(0.0) { $0 + $1.duration }
    }

    @MainActor func getLatestRunningSession() -> SessionController? {
        let running = SessionState.RUNNING.rawValue
        let predicate = #Predicate<SessionData> { session in
            session.state == running
        }
        let sorting = [SortDescriptor<SessionData>(\.started, order: .reverse)]
        var fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sorting)
        fetchDescriptor.fetchLimit = 1
        
        do {
            let unfinishedSession = try modelContainer.mainContext.fetch(fetchDescriptor)
            guard let unfinishedSession = unfinishedSession.first else { return nil }
            
            currentSession = unfinishedSession
            
            return restoreSession(with: unfinishedSession)
        } catch {
            print("")
            return nil
        }
    }
    
    @MainActor func getTodaysSessions() -> [SessionData] {
        let finished = SessionState.FINISHED.rawValue
        let (start, end) = Date.now.getStartAndEndOfDay()
        let predicate = #Predicate<SessionData>{ session in
            session.state == finished && session.started >= start && session.started < end
        }
        let sorting = [SortDescriptor<SessionData>(\.started, order: .reverse)]
        
        let fetchDescribtor = FetchDescriptor(predicate: predicate, sortBy: sorting)
        
        do {
            let todaysSessions = try modelContainer.mainContext.fetch(fetchDescribtor)
            return todaysSessions
        } catch {
            print("❌")
            return []
        }
    }
    
    
    //MARK: Helper
    private func restoreSession(with data: SessionData) -> SessionController {
        var sections = data.segments
            .map { SessionSegment(category: SessionCategory(rawValue: $0.category)!, startedAt: $0.startedAt, finishedAt: $0.finishedAt) }
            .sorted(using: [KeyPathComparator(\.startedAt, order: .forward)])
        
        if let last = sections.last, let finishedAt = last.finishedAt {
            let category: SessionCategory = last.category == SessionCategory.Focus ? .Pause : .Focus
            sections.append(.init(category: category, startedAt: finishedAt))
        } else {
            // In case there is no session segment saved yet
            sections.append(.init(category: .Focus, startedAt: data.started))
        }
        
        let session = Session(segments: sections, availableBreak: data.availableBreak, breaktimeLimit: data.breaktimeLimit, breaktimeFactor: data.breaktimeFactor)
        
        return SessionController(state: SessionState(rawValue: data.state)!, goal: data.goal, started: data.started, sections: session )
    }
}
