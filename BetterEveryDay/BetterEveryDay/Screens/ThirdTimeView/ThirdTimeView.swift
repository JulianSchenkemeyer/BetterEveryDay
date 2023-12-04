//
//  ThirdTimeView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.06.23.
//

import SwiftUI

enum ThirdTimeState: String, Codable {
    case Focus = "Focus"
    case Pause = "Pause"
    case Prepare = "Prepare"
    case Reflect = "Reflect"
}

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
                persistenceManager.createNewSession(session: viewModel.session)
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
