//
//  SwiftUIView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 17.03.24.
//

import SwiftUI


struct PrepareSessionScreen: View {
    @Environment(\.persistenceManager) var persistenceManager
    @Environment(\.restorationManager) var restorationManager
    @AppStorage("breaktimeLimit") private var breaktimeLimit: Int = 0
    @AppStorage("breaktimeFactor") private var breaktimeFactor: Double = 3
    
    @State private var sessionIsInProgress = false
    @State private var viewModel = SessionController()
    @State private var todays: [SessionData] = []
    
    @State private var showNewTaskModal: Bool = false
    
    private let sessionFactory = SessionFactory()
    
    
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
                          showNewTaskModal: $showNewTaskModal) { selectedVariant in
                
                startSession(variant: selectedVariant)
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
        }, content: {
            sessionFactory.createSessionView(with: viewModel.session, goal: viewModel.goal)
        })
        .task {
            todays = await persistenceManager?.getTodaysSessions() ?? []
            
            restoreRunningSession()
        }
    }
    
    private func startSession(variant: SessionType) {
        let sessionConfiguration = SessionConfiguration(type: variant,
                                                        focustimeLimit: 25,
                                                        breaktimeLimit: breaktimeLimit,
                                                        breaktimeFactor: breaktimeFactor)
        viewModel.start(with: sessionConfiguration)
        
        if persistenceManager != nil {
            Task {
                await persistenceManager?.insertSession(from: viewModel, configuration: sessionConfiguration)
            }
        }
        viewModel.session.next(onFinishingSegment: nil)
        
        sessionIsInProgress = true
        showNewTaskModal = false
    }
    
    private func finishSession() {
        viewModel.finish()
        Task {
            await persistenceManager?.finishSession(with: viewModel.session)
            
            viewModel.reset()
            
            todays = await persistenceManager?.getTodaysSessions() ?? []
        }
    }
    
    private func restoreRunningSession() {
        Task {
            let unfinished = await persistenceManager?.getLatestRunningSession() ?? nil
            guard let unfinished else { return }
            
            let restored = restorationManager?.restoreSessions(from: unfinished) {
                untracked in
                persistenceManager?.updateSession(with: untracked)
            }
            guard let restored else { return }

            viewModel.restore(state: restored.state,
                              goal: restored.goal,
                              started: restored.started,
                              session: restored.session)
            
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
    .environment(\.restorationManager, RestorationManager())
    .environment(NotificationManager(notificationService: NotificationServiceMock()))
}
