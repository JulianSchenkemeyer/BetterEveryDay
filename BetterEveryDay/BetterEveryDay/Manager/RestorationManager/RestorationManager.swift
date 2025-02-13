//
//  RestorationManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.02.25.
//
import Foundation


typealias RunningSessionData = (goal: String, started: Date, session: SessionProtocol, state: SessionState)

protocol RestorationManagerProtocol {
    func restoreSessions(from data: SessionData, onRestoredSegments: (([SessionSegment]) -> Void)?) -> RunningSessionData
}

final class RestorationManager: RestorationManagerProtocol {
    private var factory = SessionRestoratorFactory()
    
    func restoreSessions(from data: SessionData, onRestoredSegments: (([SessionSegment]) -> Void)? = nil) -> RunningSessionData {
        let type = identifySessionType(data)
        let restorator = factory.createRestorator(for: type)
        
        return restorator.restore(data, onRestoredSegments: onRestoredSegments)
    }
    
    private func identifySessionType(_ data: SessionData) -> SessionType {
        SessionType(rawValue: data.type) ?? .flexible
    }
}
