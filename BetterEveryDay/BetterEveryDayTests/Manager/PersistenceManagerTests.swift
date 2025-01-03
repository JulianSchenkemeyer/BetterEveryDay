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
    
    init() {
        persistenceManager = SwiftDataPersistenceManager(configuration: .init(isStoredInMemoryOnly: true))
    }
    
    func fetchAll() -> [SessionData] {
        let fetchDescriptor = FetchDescriptor<SessionData>()
        return try! persistenceManager.context.fetch(fetchDescriptor)
    }
    
    @Test func initPersistencManager() throws {
        #expect(persistenceManager.modelContainer != nil)
        #expect(persistenceManager.context != nil)
        
        let results = fetchAll()
        #expect(results.isEmpty)
    }
    
    @Test func insertSessionData() async throws {
        let sessionController = SessionController()
        await persistenceManager.insertSession(from: sessionController)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
    }
    
    @Test func updateSessionData() async throws {
        let sessionController = SessionController()
        await persistenceManager.insertSession(from: sessionController)
        
        let now = Date.now
        let inFiveMinutes = Calendar.current.date(byAdding: .minute, value: 5, to: now)
        let segment = SessionSegment(category: .Focus, startedAt: now, finishedAt: inFiveMinutes)

        persistenceManager.updateSession(with: 0.0, segment: segment)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
        #expect(results[0].segments.count == 1)
        #expect(results[0].duration == (5 * 60))
    }
    
    @Test func updateSessionDataMultipleTimes() async throws {
        let sessionController = SessionController()
        await persistenceManager.insertSession(from: sessionController)
        
        let now = Date.now
        let inSixMinutes = Calendar.current.date(byAdding: .minute, value: 6, to: now)!
        let focusSegment = SessionSegment(category: .Focus, startedAt: now, finishedAt: inSixMinutes)

        persistenceManager.updateSession(with: 0.0, segment: focusSegment)
        
        let inEightMinutes = Calendar.current.date(byAdding: .minute, value: 8, to: now)!
        let pauseSegment = SessionSegment(category: .Pause, startedAt: inSixMinutes, finishedAt: inEightMinutes)
        
        persistenceManager.updateSession(with: 120.0, segment: pauseSegment)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
        #expect(results[0].segments.count == 2)
        #expect(results[0].duration == (8 * 60))
        #expect(results[0].availableBreak == 120)
    }
    
    @Test func finishSessionData() async throws {
        let sessionController = SessionController()
        let session = sessionController.session
        await persistenceManager.insertSession(from: sessionController)
        
        let now = Date.now
        let inFiveMinutes = Calendar.current.date(byAdding: .minute, value: 5, to: now)
        let segment = SessionSegment(category: .Focus, startedAt: now, finishedAt: inFiveMinutes)
        session.segments.append(segment)

        persistenceManager.updateSession(with: 0.0, segment: segment)
        persistenceManager.finishSession(with: session)
        
        let results = fetchAll()
        
        #expect(results.count == 1)
        #expect(results[0].state == SessionState.FINISHED.rawValue)
        #expect(results[0].segments.count == 1)
        #expect(results[0].duration == (5 * 60))
    }
    
    @Test func getTodaysData() async throws {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
        let sessionControllerPreviousDay = SessionController(started: yesterday)
        await persistenceManager.insertSession(from: sessionControllerPreviousDay)
        persistenceManager.finishSession(with: sessionControllerPreviousDay.session)
        
        let sessionController = SessionController()
        await persistenceManager.insertSession(from: sessionController)
        persistenceManager.finishSession(with: sessionController.session)
        
        let allResults = fetchAll()
        let todaysResults = persistenceManager.getTodaysSessions()
        
        #expect(allResults.count == 2)
        #expect(todaysResults.count == 1)
    }
    
    @Test func getDataFromLatestRunningSession() async throws {
        #expect(persistenceManager.getLatestRunningSession() == nil)
        
        let sessionController = SessionController()
        sessionController.start(with: 3, factor: 1.0)
        await persistenceManager.insertSession(from: sessionController)
        
        #expect(persistenceManager.getLatestRunningSession() != nil)
        
        persistenceManager.finishSession(with: sessionController.session)
        #expect(persistenceManager.getLatestRunningSession() == nil)
    }
}
