//
//  SessionScreenFactory.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.02.25.
//
import SwiftUI


struct SessionFactory {
    func createSessionView(with session: SessionProtocol, goal: String) -> some View {
        switch session.type {
        case .flexible:
            AnyView(FlexibleSessionScreen(goal: goal, viewModel: session))
        case .fixed:
            AnyView(FixedSessionScreen(goal: goal, viewModel: session))
        }
    }
}
