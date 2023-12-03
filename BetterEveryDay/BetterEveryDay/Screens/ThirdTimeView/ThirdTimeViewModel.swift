//
//  ThirdTimeViewModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 09.07.23.
//

import SwiftUI


@MainActor final class ThirdTimeViewModel: ObservableObject {
    
    private let sessionFactory: SessionFactory
    
    var phaseTimer: PhaseTimerProtocol?
    var session: SessionProtocol
    var limit: Int = 0

    @Published var sessionGoal = ""
    @Published var goingIntoOvertime = false
    @Published var availableBreakTime = 0.0
    @Published var phase: ThirdTimeState {
        willSet(newPhase) {
            // Finish previous phase
            appendPhaseToHistory()
            phaseTimer = nil
            
            if phase == .Prepare {
                self.session = sessionFactory.createSession(with: Double(limit))
                self.session.goal = sessionGoal
            }
            
            if phase == .Focus && newPhase == .Pause {
                availableBreakTime = session.availableBreakTime
                scheduleOvertime()
                
            }
            if phase == .Pause && (newPhase == .Focus || newPhase == .Reflect) {
                availableBreakTime = session.availableBreakTime
                goingIntoOvertime = false
            }
        }
        didSet {
            // Setup new phase
            switch phase {
            case .Prepare:
                reset()
            case .Focus:
                phaseTimer = PhaseTimer(displayStart: Date.now)
             
            case .Pause:
                phaseTimer = PhaseTimer(add: availableBreakTime)
                
            case .Reflect:
                session.setToFinish()
            }
        }
    }
    
    init(phase: ThirdTimeState = .Prepare) {
        self.phase = phase
        self.sessionFactory = SessionFactory()
        self.session = sessionFactory.createSession(with: 0)
        
        switch phase {
        case .Prepare, .Reflect:
            break
        case .Focus, .Pause:
            phaseTimer = PhaseTimer(displayStart: Date.now)
        }
    }
    
    private func reset() {
        phaseTimer = nil
    }
    
    private func appendPhaseToHistory() {
        if let previousTimer = phaseTimer {
            let marker = PhaseMarker(previousTimer, phase: phase)
            session.append(phase: marker)
        }
    }
    
    private func scheduleOvertime() {
        Task {
            guard availableBreakTime > 0 else {
                goingIntoOvertime = true
                return
            }
            try? await waitFor(seconds: availableBreakTime)
            self.goingIntoOvertime = true
            print("Gone into overtime")
        }
    }
}
