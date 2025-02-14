//
//  SessionionRestoratorFactory.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//


/// Factory class to create the matching ``SessionRestoratorProtocol`` Instance to a ``SessionType``
final class SessionRestoratorFactory {
    
    /// Create a SessionRestorator instance to restore a session of the given type
    /// - Parameter sessionType: ``SessionType`` of the session, which is to be restored with this Restorator
    /// - Returns: SessionRestorator Instance
    func createRestorator(for sessionType: SessionType) -> SessionRestoratorProtocol {
        switch sessionType {
        case .fixed:
            FixedSessionRestorator()
        case .flexible:
            FlexibleSessionRestorator()
        }
    }
}
