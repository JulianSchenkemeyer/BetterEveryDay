//
//  SessionScreenFactory.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.02.25.
//
import SwiftUI


/// A factory for creating session views.
struct SessionFactory {
    
    /// Creates a session view based on the session type.
    /// - Parameters:
    ///   - session: The session conforming to `SessionProtocol`.
    ///   - goal: A string representing the session's goal.
    /// - Returns: A SwiftUI view representing the session.
    func createSessionView(with session: SessionProtocol, goal: String) -> some View {
        switch session.type {
        case .flexible:
            AnyView(FlexibleSessionScreen(goal: goal, viewModel: session))
        case .fixed:
            AnyView(FixedSessionScreen(goal: goal, viewModel: session))
        }
    }
}
