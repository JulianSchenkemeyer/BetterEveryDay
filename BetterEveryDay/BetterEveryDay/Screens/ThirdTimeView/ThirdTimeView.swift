//
//  ThirdTimeView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.06.23.
//

import SwiftUI

enum ThirdTimeState {
    case Focus, Pause, Prepare, Reflect
}

struct ThirdTimeView: View {
    
    @EnvironmentObject var notificationManager: NotificationManager
    @Binding var breaktimeLimit: Int
    @StateObject private var viewModel = ThirdTimeViewModel()
    
    
    var body: some View {
        VStack {
            switch viewModel.phase {
            case .Prepare:
                PrepareSessionView(state: $viewModel.phase)
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
            print("--- Update breaktime to \($0) ---")
            viewModel.limit = $0
        }
        .onAppear {
            print("--- Set initial breaktime to \(breaktimeLimit)")
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
        ThirdTimeView(breaktimeLimit: .constant(0))
    }
}
