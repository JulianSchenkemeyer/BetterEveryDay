//
//  RestorationManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.02.25.
//
import Foundation


typealias LatestSessionData = (goal: String, started: Date, session: SessionProtocol, state: SessionState)

protocol RestorationManagerProtocol {
    func restoreSessions(from data: SessionData, onRestoredSegments: (([SessionSegment]) -> Void)?) -> LatestSessionData
}

final class RestorationManager: RestorationManagerProtocol {
    private var factory = SessionRestoratorFactory()
    
    func restoreSessions(from data: SessionData, onRestoredSegments: (([SessionSegment]) -> Void)? = nil) -> LatestSessionData {
        let type = identifySessionType(data)
        let restorator = factory.createRestorator(for: type)
        
        return restorator.restore(data, onRestoredSegments: onRestoredSegments)
    }
    
    private func identifySessionType(_ data: SessionData) -> SessionType {
        SessionType(rawValue: data.type) ?? .flexible
    }
}
