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
    @State private var todays: [SessionData] = []
    
    @State private var showNewTaskModal: Bool = false
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                TodayOverview(todaysSessions: todays)
                TodayTimeDistribution(todaysSessions: todays)
                TodayGoalList(todaysSessions: todays)
            }
            .padding()
        }
        .opacity(showNewTaskModal ? 0.5 : 1)
        .blur(radius: showNewTaskModal ? 1.5 : 0)
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            AddNewSession(sessionGoal: $viewModel.goal,
                          showNewTaskModal: $showNewTaskModal) {
                startSession()
            }
        }
        .navigationTitle("Today")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text(.now, format: .dateTime.day().month().year())
                    .foregroundStyle(.secondary)
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .fullScreenCover(isPresented: $sessionIsInProgress, onDismiss: {
            finishSession()
            resetSessionController()
            Task {
                todays = await persistenceManager?.getTodaysSessions() ?? []
            }
        }, content: {
            SessionScreen(goal: viewModel.goal, viewModel: viewModel.session)
        })
        .task {
            todays = await persistenceManager?.getTodaysSessions() ?? []
            
            restoreRunningSession()
        }
    }
    
    private func startSession() {
        viewModel.start(with: breaktimeLimit, factor: breaktimeFactor)
        
        if persistenceManager != nil {
            Task {
                await persistenceManager?.insertSession(from: viewModel)
            }
        }
        viewModel.session.next()
        
        sessionIsInProgress = true
        showNewTaskModal = false
    }
    
    private func finishSession() {
        viewModel.finish()
        Task {
            await persistenceManager?.finishSession(with: viewModel.session)
        }
    }
    
    private func resetSessionController() {
        viewModel.goal = ""
        viewModel.started = nil
        viewModel.session = ThirdTimeSession(breaktimeLimit: breaktimeLimit, breaktimeFactor: breaktimeFactor)
    }
    
    private func restoreRunningSession() {
        Task {
            let unfinished = await persistenceManager?.getLatestRunningSession() ?? nil
            guard let unfinished else { return }

            viewModel.restore(goal: unfinished.goal,
                              started: unfinished.started,
                              session: unfinished.session,
                              state: unfinished.state)
            
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                sessionIsInProgress = true
            }
        }
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
