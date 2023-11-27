//
//  ThirdTimeView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.06.23.
//

import SwiftUI

enum ThirdTimeState: String {
    case Focus = "Focus"
    case Pause = "Pause"
    case Prepare = "Prepare"
    case Reflect = "Reflect"
}

struct ThirdTimeView: View {
    
    @EnvironmentObject var notificationManager: NotificationManager
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
                                 goneIntoOvertime: $viewModel.goingIntoOvertime,
                                 start: viewModel.phaseTimer)
            case .Reflect:
                ReflectSessionView(state: $viewModel.phase,
                                   session: viewModel.session)
            }
        }
        .onChange(of: viewModel.phase) {
            if ($0 == .Pause) {
                guard viewModel.availableBreakTime > 0 else { return }
                schedulePauseEndedNotification()
            }
            
            if ($0 == .Focus) {
                removeScheduledNotifications()
            }
            
        }
        .onChange(of: breaktimeLimit) {
            viewModel.limit = $0
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
