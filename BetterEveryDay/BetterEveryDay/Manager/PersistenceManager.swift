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
    /// - Parameters:
    ///  - sessionController: ``SessionController``  to be persisted
    ///  - configuration: ``SessionConfiguration``
    func insertSession(from sessionController: SessionController, configuration: SessionConfiguration) async
    
    /// Update the currently running session entry in the persistence layer
    /// - Parameters:
    ///   - availableBreaktime: new value for the available breaktime
    ///   - segment: new ``SessionSegment`` to be added to the currently running session
    func updateSession(with availableBreaktime: TimeInterval, segment: SessionSegment) async
    
    
    /// Update the currently running session entry in the persistence layer
    /// - Parameter segments: array of ``SessionSegment`` to be added to the running session
    func updateSession(with segments: [SessionSegment])
    
    /// Finish the running session entry in the persistence layer, which sets the state of the entry to finished
    /// - Parameter session: to be persisted
    func finishSession(with session: SessionProtocol) async
    
    /// Get the latest running session from the persistence layer
    /// - Returns: the latest running session or nil if non could be found
    func getLatestRunningSession() async -> SessionData?
    
    /// Get all finished session which were started today
    /// - Returns: array of ``SessionData``
    func getTodaysFinishedSessions() async -> [SessionData]
}

/// Mock implementation of ``PersistenceManagerProtocol`` for use in Previews or tests
final class PersistenceManagerMock: PersistenceManagerProtocol {
    func insertSession(from sessionController: SessionController, configuration: SessionConfiguration) { }
    func updateSession(with availableBreaktime: TimeInterval, segment: SessionSegment) { }
    func updateSession(with segments: [SessionSegment]) { }
    func finishSession(with session: SessionProtocol) { }
    func getLatestRunningSession() -> SessionData? { nil }
    func getTodaysFinishedSessions() -> [SessionData] { Mockdata.sessionDataArray }
}

/// SwiftData implementation of ``PersistenceManagerProtocol``
final class SwiftDataPersistenceManager: PersistenceManagerProtocol {
    private var currentSession: SessionData?
    private(set) var modelContainer: ModelContainer
    private(set) var context: ModelContext
    
    
    /// Init an instance of SwiftDataPersistenceManager
    /// - Parameter configuration: ModelConfiguration, can be used to switch the SwiftData persistence layer to memory only for use in tests.
    ///                         Defaults to a default ModelConfiguration
    init(configuration: ModelConfiguration = .init(isStoredInMemoryOnly: false)) {
        func createContainer() -> ModelContainer {
            let schema = Schema([SessionData.self])
            do {
                let container = try ModelContainer(for: schema, configurations: configuration)
                return container
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        self.modelContainer = createContainer()
        
        context = .init(self.modelContainer)
    }
    
    func insertSession(from sessionController: SessionController, configuration: SessionConfiguration) async {
        let session = sessionController.session
        let sessionSegments: [SessionSegmentData] = []
        let sessionDuration = 0.0
        
        let newSessionData = SessionData(type: configuration.type.rawValue,
                                         state: sessionController.state.rawValue,
                                         goal: sessionController.goal,
                                         started: sessionController.started ?? .now,
                                         focusTimeLimit: configuration.focustimeLimit,
                                         breaktimeLimit: configuration.breaktimeLimit,
                                         breaktimeFactor: configuration.breaktimeFactor,
                                         availableBreak: session.availableBreak,
                                         duration: sessionDuration,
                                         timeSpendWork: 0,
                                         timeSpendPause: 0,
                                         segments: sessionSegments)
        currentSession = newSessionData
        
        context.insert(newSessionData)
        try? context.save()
    }
    
    func updateSession(with availableBreaktime: TimeInterval, segment: SessionSegment) {
        guard let currentSession else {
            print("❌ no current session")
            return
        }
        
        
        currentSession.availableBreak = availableBreaktime
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
        
        try? context.save()
    }
    
    func updateSession(with segments: [SessionSegment]) {
        guard let currentSession else {
            print("❌ no current session")
            return
        }
        var availableBreaktime: TimeInterval = 0
        var duration: TimeInterval = 0
        var timeSpendWork: TimeInterval = 0
        var timeSpendPause: TimeInterval = 0
        
        for segment in segments {
            duration += segment.duration
            
            switch segment.category {
            case .Focus:
                timeSpendWork += segment.duration
                availableBreaktime = TimeInterval(currentSession.breaktimeLimit)
            case .Pause:
                timeSpendPause += segment.duration
                availableBreaktime = 0
            }
        }
        
        
        let segmentsData: [SessionSegmentData] = segments.map { .init(category: $0.category.rawValue, startedAt: $0.startedAt, finishedAt: $0.finishedAt, duration: $0.duration) }
        currentSession.segments.append(contentsOf: segmentsData)
        currentSession.availableBreak = availableBreaktime
        currentSession.duration += duration
        currentSession.timeSpendWork += timeSpendWork
        currentSession.timeSpendPause += timeSpendPause
        
        try? context.save()
    }
    
    func finishSession(with session: SessionProtocol) {
        guard let currentSession else {
            print("❌ no current session")
            return
        }
        
        currentSession.state = "Finished"
        currentSession.availableBreak = session.availableBreak
        currentSession.duration = session.segments.reduce(0.0) { $0 + $1.duration }
        
        try? context.save()
    }
    
    func getLatestRunningSession() -> SessionData? {
        let running = SessionState.RUNNING.rawValue
        let predicate = #Predicate<SessionData> { session in
            session.state == running
        }
        let sorting = [SortDescriptor<SessionData>(\.started, order: .reverse)]
        var fetchDescriptor = FetchDescriptor(predicate: predicate, sortBy: sorting)
        fetchDescriptor.fetchLimit = 1
        
        do {
            let unfinishedSession = try context.fetch(fetchDescriptor)
            guard let unfinishedSession = unfinishedSession.first else { return nil }
            
            currentSession = unfinishedSession
            
            return unfinishedSession
        } catch {
            print("")
            return nil
        }
    }
    
    func getTodaysFinishedSessions() -> [SessionData] {
        let finished = SessionState.FINISHED.rawValue
        let (start, end) = Date.now.getStartAndEndOfDay()
        let predicate = #Predicate<SessionData>{ session in
            session.state == finished && session.started >= start && session.started < end
        }
        let sorting = [SortDescriptor<SessionData>(\.started, order: .reverse)]
        
        let fetchDescribtor = FetchDescriptor(predicate: predicate, sortBy: sorting)
        
        do {
            let todaysSessions = try context.fetch(fetchDescribtor)
            return todaysSessions
        } catch {
            print("❌")
            return []
        }
    }
}
