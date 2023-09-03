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
    
    @ObservedObject private var viewModel: ThirdTimeViewModel
    
    init(notificationService: NotificationServiceProtocol) {
        
        let notificationManager = NotificationManager(notificationService: notificationService)
        self.viewModel = ThirdTimeViewModel(notificationManager: notificationManager)
        
    }
    
    var body: some View {
        VStack {
            switch viewModel.phase {
            case .Prepare:
                PrepareSessionView(state: $viewModel.phase,
                                   isLimited: $viewModel.pauseIsLimited)
            case .Focus:
                FocusSessionView(state: $viewModel.phase,
                                 start: viewModel.phaseTimer)
            case .Pause:
                PauseSessionView(state: $viewModel.phase,
                                 start: viewModel.phaseTimer)
            case .Reflect:
                ReflectSessionView(state: $viewModel.phase,
                                   session: viewModel.session)
            }
        }
    }
}

struct ThirdTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdTimeView(notificationService: NotificationService(notificationCenter: .current()))
    }
}
