//
//  ThirdTimeViewModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 09.07.23.
//

import SwiftUI


final class ThirdTimeViewModel: ObservableObject {
    
    let notificationManager: NotificationManagerProtocol
    
    var pauseIsLimited = false
    
    var phaseTimer: PhaseTimer?
    var session: Session

    @Published var availableBreakTime = 0.0
    @Published var phase: ThirdTimeState {
        willSet(newPhase) {
            // Finish previous phase
            appendPhaseToHistory()
            phaseTimer = nil
            
            if phase == .Focus && newPhase == .Pause {
                availableBreakTime = session.availableBreaktime
            }
            if phase == .Pause && (newPhase == .Focus || newPhase == .Reflect) {
                availableBreakTime = session.availableBreaktime
                notificationManager.removeScheduledNotifications()
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
                scheduleNotifications()
                
            case .Reflect:
                session.setToFinish()
            }
        }
    }
    
    init(phase: ThirdTimeState = .Prepare, notificationManager: NotificationManagerProtocol) {
        self.phase = phase
        self.notificationManager = notificationManager
        self.session = Session()
        
        switch phase {
        case .Prepare, .Reflect:
            break
        case .Focus, .Pause:
            phaseTimer = PhaseTimer(displayStart: Date.now)
        }
    }
    
    private func reset() {
        phaseTimer = nil
        session = Session()
    }
    
    private func appendPhaseToHistory() {
        if let previousTimer = phaseTimer {
            let marker = PhaseMarker(previousTimer, phase: phase)
            session.append(phase: marker)
        }
    }
    
    private func scheduleNotifications() {
        guard availableBreakTime > 0 else { return }
        
        let pauseEnds = Date.now.addingTimeInterval(availableBreakTime)
        let notification = PauseEndedNotification(triggerAt: pauseEnds)
        notificationManager.schedule(notification: notification)
    }
}
