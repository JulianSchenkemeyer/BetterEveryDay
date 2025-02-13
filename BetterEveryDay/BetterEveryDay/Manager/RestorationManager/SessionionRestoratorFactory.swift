//
//  SessionionRestoratorFactory.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//


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
