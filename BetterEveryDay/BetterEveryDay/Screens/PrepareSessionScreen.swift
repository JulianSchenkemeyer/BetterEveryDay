//
//  SwiftUIView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 17.03.24.
//

import SwiftUI

struct PrepareSessionScreen: View {
    @Environment(\.persistenceManager) var persistenceManager
    @AppStorage("breaktimeLimit") private var breaktimeLimit: Int = 0
    @AppStorage("breaktimeFactor") private var breaktimeFactor: Double = 3
    
    @State private var sessionIsInProgress = false
    @State private var viewModel = SessionController()
    
    var body: some View {
        VStack(spacing: 40) {
            TodayOverview()
            
            VStack(spacing: 30) {
                TextField("Your Goal for the Session",
                          text: $viewModel.goal,
                          axis: .vertical)
                    .lineLimit(1...)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .submitLabel(.go)

                
                Button {
                    startSession()
                } label: {
                    Label("Start Session", systemImage: "play")
                }
                .primaryButtonStyle()
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 100)
        .navigationTitle("Prepare")
        .navigationBarTitleDisplayMode(.automatic)
        .fullScreenCover(isPresented: $sessionIsInProgress, onDismiss: {
            finishSession()
            resetSessionController()
            todays = persistenceManager?.getTodaysSessions() ?? []
        }, content: {
            SessionScreen(goal: viewModel.goal, viewModel: viewModel.session)
        })
        .onAppear {
            todays = persistenceManager?.getTodaysSessions() ?? []
            
            restoreRunningSession()
        }
    }
    
    private func startSession() {
        viewModel.state = .RUNNING
        viewModel.started = .now
        viewModel.session = Session(breaktimeLimit: breaktimeLimit, breaktimeFactor: breaktimeFactor)
        if persistenceManager != nil {
            persistenceManager?.insertSession(from: viewModel)
        }
        viewModel.session.next()
        sessionIsInProgress = true
    }
    
    private func finishSession() {
        viewModel.state = .FINISHED
        persistenceManager?.finishSession(with: viewModel.session)
    }
    
    private func resetSessionController() {
        viewModel.goal = ""
        viewModel.started = nil
        viewModel.session = Session(breaktimeLimit: breaktimeLimit, breaktimeFactor: breaktimeFactor)
    }
    
    private func restoreRunningSession() {
        let unfinished = persistenceManager?.getLatestRunningSession() ?? nil
        guard let unfinished else { return }
        viewModel = unfinished
        sessionIsInProgress = true
    }
}

#Preview {
    TabView {
        NavigationStack {
            PrepareSessionScreen()
        }
        .tabItem {
            Label("Timer", systemImage: "clock")
        }
        NavigationStack {
            SettingsView()
                .navigationTitle("Settings")
        }
        .tabItem {
            Label("Settings", systemImage: "gear")
        }
    }
    .environment(\.persistenceManager, PersistenceManagerMock())
    .environment(NotificationManager(notificationService: NotificationServiceMock()))
}
