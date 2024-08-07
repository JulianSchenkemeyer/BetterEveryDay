//
//  ThirdTimeView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.06.23.
//

import SwiftUI


struct ThirdTimeView: View {
    
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var persistenceManager: SwiftDataPersistenceManager
    @AppStorage("breaktimeLimit") private var breaktimeLimit: Int = 0
    @StateObject private var viewModel = ThirdTimeViewModel()
    
    
    var body: some View {
        VStack(spacing: 10) {
            Text(viewModel.phase.rawValue)
                .modifier(PhaseLabelModifier())
            
            if (viewModel.phase != .Prepare) {
                Text(viewModel.sessionGoal)
                    .font(.title3)
            }
            
            
            switch viewModel.phase {
            case .Prepare:
                PrepareSessionView(state: $viewModel.phase, goal: $viewModel.sessionGoal)
            case .Focus:
                FocusSessionView(state: $viewModel.phase,
                                 start: viewModel.phaseTimer)
            case .Pause:
                PauseSessionView(state: $viewModel.phase,
                                 availableBreaktime: $viewModel.availableBreakTime,
                                 start: viewModel.phaseTimer)
            case .Reflect:
                ReflectSessionView(state: $viewModel.phase,
                                   session: viewModel.session)
            }
        }
        .onChange(of: viewModel.phase) { old, new in
            if (new == .Pause) {
                guard viewModel.availableBreakTime > 0 else { return }
                schedulePauseEndedNotification()
                
                persistenceManager.update(session: viewModel.session)
            }
            
            if (new == .Focus) {
                removeScheduledNotifications()
                
                persistenceManager.update(session: viewModel.session)
            }
            
            if (old == .Prepare) {
                if persistenceManager.currentSession == nil {
                    persistenceManager.createNewSession(session: viewModel.session, breakLimit: TimeInterval(viewModel.limit))
                }
            }
            if (new == .Reflect) {
                persistenceManager.finishRunningSession()
            }
        }
        .onChange(of: breaktimeLimit) { old, new in
            viewModel.limit = new
        }
        .onAppear {
            viewModel.limit = breaktimeLimit
            restorePreviousSession()
        }
    }
    
    private func restorePreviousSession() {
        if persistenceManager.currentSession == nil {
            let unfinishedSession = persistenceManager.getLatestRunningSession()
            guard let unfinishedSession else { return }
            
            viewModel.restore(session: unfinishedSession)
        }
    }
    
    private func schedulePauseEndedNotification() {
        let breaktime = viewModel.availableBreakTime
        
        let triggerDate = Date.now.addingTimeInterval(breaktime)
        let notification = PauseEndedNotification(triggerAt: triggerDate)
        notificationManager.schedule(notification: notification)
    }
    
    private func removeScheduledNotifications() {
        notificationManager.removeScheduledNotifications()
    }
}

struct ThirdTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdTimeView()
    }
}
