//
//  PersistenceManagerTests.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 31.12.24.
//
import Testing
import SwiftData
@testable import BetterEveryDay
import Foundation


@Suite class PersistenceManagerTests {
    let persistenceManager: SwiftDataPersistenceManager
    let context: ModelContext
    
    init() {
        persistenceManager = SwiftDataPersistenceManager(configuration: .init(isStoredInMemoryOnly: true))
        context = ModelContext(persistenceManager.modelContainer)
    }
    
    func fetchAll() -> [SessionData] {
        let fetchDescriptor = FetchDescriptor<SessionData>()
        return try! context.fetch(fetchDescriptor)
    }
    
    @Test func initPersistencManager() throws {
        #expect(persistenceManager.modelContainer != nil)
        
        let results = fetchAll()
        #expect(results.isEmpty)
    }
    
    @Test func insertSessionData() async throws {
        let sessionController = SessionController()
        let sessionConfiguration = SessionConfiguration(type: .flexible,
                                                        focustimeLimit: 0,
                                                        breaktimeLimit: 0,
                                                        breaktimeFactor: 0)
        try await persistenceManager.insertSession(from: sessionController, configuration: sessionConfiguration)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
    }
    
    @Test func updateSessionData() async throws {
        let sessionController = SessionController()
        let sessionConfiguration = SessionConfiguration(type: .flexible,
                                                        focustimeLimit: 0,
                                                        breaktimeLimit: 0,
                                                        breaktimeFactor: 0)
        try await persistenceManager.insertSession(from: sessionController, configuration: sessionConfiguration)
        
        let now = Date.now
        let inFiveMinutes = Calendar.current.date(byAdding: .minute, value: 5, to: now)
        let segment = SessionSegment(category: .Focus, startedAt: now, finishedAt: inFiveMinutes)

        try await persistenceManager.updateSession(with: 0.0, segment: segment)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
        #expect(results[0].segments.count == 1)
        #expect(results[0].duration == (5 * 60))
    }
    
    @Test func updateSessionDataMultipleTimes() async throws {
        let sessionController = SessionController()
        let sessionConfiguration = SessionConfiguration(type: .flexible,
                                                        focustimeLimit: 0,
                                                        breaktimeLimit: 0,
                                                        breaktimeFactor: 0)
        try await persistenceManager.insertSession(from: sessionController, configuration: sessionConfiguration)
        
        let now = Date.now
        let inSixMinutes = Calendar.current.date(byAdding: .minute, value: 6, to: now)!
        let focusSegment = SessionSegment(category: .Focus, startedAt: now, finishedAt: inSixMinutes)

        try await persistenceManager.updateSession(with: 0.0, segment: focusSegment)
        
        let inEightMinutes = Calendar.current.date(byAdding: .minute, value: 8, to: now)!
        let pauseSegment = SessionSegment(category: .Pause, startedAt: inSixMinutes, finishedAt: inEightMinutes)
        
        try await persistenceManager.updateSession(with: 120.0, segment: pauseSegment)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
        #expect(results[0].segments.count == 2)
        #expect(results[0].duration == (8 * 60))
        #expect(results[0].availableBreak == 120)
    }
    
    @Test func finishSessionData() async throws {
        let sessionController = SessionController()
        var session = sessionController.session
        let sessionConfiguration = SessionConfiguration(type: .fixed,
                                                        focustimeLimit: 0,
                                                        breaktimeLimit: 0,
                                                        breaktimeFactor: 0)
        try await persistenceManager.insertSession(from: sessionController, configuration: sessionConfiguration)
        
        let now = Date.now
        let inFiveMinutes = Calendar.current.date(byAdding: .minute, value: 5, to: now)
        let segment = SessionSegment(category: .Focus, startedAt: now, finishedAt: inFiveMinutes)
        session.segments.append(segment)

        try await persistenceManager.updateSession(with: 0.0, segment: segment)
        try await persistenceManager.finishSession(with: session)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
        #expect(results[0].state == SessionState.FINISHED.rawValue)
        #expect(results[0].segments.count == 1)
        #expect(results[0].duration == (5 * 60))
    }
    
    @Test func getTodaysData() async throws {
        let sessionConfiguration = SessionConfiguration(type: .flexible,
                                                        focustimeLimit: 0,
                                                        breaktimeLimit: 0,
                                                        breaktimeFactor: 0)
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
        let sessionControllerPreviousDay = SessionController(started: yesterday)
        try await persistenceManager.insertSession(from: sessionControllerPreviousDay, configuration: sessionConfiguration)
        try await persistenceManager.finishSession(with: sessionControllerPreviousDay.session)
        
        let sessionController = SessionController()
        try await persistenceManager.insertSession(from: sessionController, configuration: sessionConfiguration)
        try await persistenceManager.finishSession(with: sessionController.session)
        
        let allResults = fetchAll()
        let todaysResults = await persistenceManager.getFinishedSessions(for: .now)
        
        #expect(allResults.count == 2)
        #expect(todaysResults.count == 1)
    }
    
    @Test func getDataFromLatestRunningSession() async throws {
        #expect(await persistenceManager.getLatestRunningSession() == nil)
        
        let sessionController = SessionController()
        let sessionConfiguration = SessionConfiguration(type: .flexible,
                                                        focustimeLimit: 0,
                                                        breaktimeLimit: 3,
                                                        breaktimeFactor: 1.0)
        sessionController.start(with: sessionConfiguration)
        try await persistenceManager.insertSession(from: sessionController, configuration: sessionConfiguration)
        
        #expect(await persistenceManager.getLatestRunningSession() != nil)
        
        try await persistenceManager.finishSession(with: sessionController.session)
        #expect(await persistenceManager.getLatestRunningSession() == nil)
    }
}
