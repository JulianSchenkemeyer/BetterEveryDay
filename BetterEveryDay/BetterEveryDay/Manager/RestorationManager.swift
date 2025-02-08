//
//  RestorationManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.02.25.
//
import Foundation


protocol RestorationManagerProtocol {
    func restoreSessions(with data: SessionData) -> LatestSessionData
}

final class RestorationManager: RestorationManagerProtocol {
    private var factory = SessionRestoratorFactory()
    
    func restoreSessions(with data: SessionData) -> LatestSessionData {
        let type = identifySessionType(data)
        let restorator = factory.createRestorator(for: type)
        
        return restorator.restore(data)
    }
    
    private func identifySessionType(_ data: SessionData) -> SessionType {
        SessionType(rawValue: data.type) ?? .flexible
    }
}

final class SessionRestoratorFactory {
    func createRestorator(for sessionType: SessionType) -> SessionRestoratorProtocol {
        switch sessionType {
        case .fixed:
            FixedSessionRestorator()
        case .flexible:
            FlexibleSessionRestorator()
        }
    }
}

protocol SessionRestoratorProtocol {
    //TODO: Persist Updated Data
    func restore(_ data: SessionData) -> LatestSessionData
}

extension SessionRestoratorProtocol {
    func restoreSegments(_ data: SessionData) -> [SessionSegment] {
        data.segments
            .map { SessionSegment(category: SessionCategory(rawValue: $0.category)!, startedAt: $0.startedAt, finishedAt: $0.finishedAt) }
            .sorted(using: [KeyPathComparator(\.startedAt, order: .forward)])
    }
}

final class FlexibleSessionRestorator: SessionRestoratorProtocol {
    func restore(_ data: SessionData) -> LatestSessionData {
        var segments = restoreSegments(data)
        
        if let last = segments.last, let finishedAt = last.finishedAt {
            let category: SessionCategory = last.category == SessionCategory.Focus ? .Pause : .Focus
            segments.append(.init(category: category, startedAt: finishedAt))
        } else {
            // In case there is no session segment saved yet
            segments.append(.init(category: .Focus, startedAt: data.started))
        }
        
        let session = ThirdTimeSession(segments: segments, availableBreak: data.availableBreak, breaktimeLimit: data.breaktimeLimit, breaktimeFactor: data.breaktimeFactor)
        return (goal: data.goal,
                started: data.started,
                session: session,
                state: SessionState(rawValue: data.state)! )
    }
}

final class FixedSessionRestorator: SessionRestoratorProtocol {
    func restore( _ data: SessionData) -> LatestSessionData {
        var segments = restoreSegments(data)
        
        // Restore running session in fixed session (Classic)
        let now = Date.now
        var segmentStart = segments.last?.finishedAt ?? data.started
        
        
        while now > segmentStart {
            let category: SessionCategory = if segments.last?.category == .Focus {
                .Pause
            } else {
                .Focus
            }
            let duration = category == .Focus ? data.focusTimeLimit : data.breaktimeLimit
            
            let finishedAt = Calendar.current.date(byAdding: .minute, value: duration, to: segmentStart)!
            segments.append(.init(category: category, startedAt: segmentStart, finishedAt: finishedAt))
            
            segmentStart = finishedAt
        }
        
        let session = ClassicSession(segments: segments, focustimeLimit: data.focusTimeLimit, breaktimeLimit: data.breaktimeLimit)
        return (goal: data.goal,
                started: data.started,
                session: session,
                state: SessionState(rawValue: data.state)! )
    }
}
