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
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("flexBreaktimeLimit") private var flexBreaktimeLimit: Int = 0
    @AppStorage("flexBreaktimeFactor") private var flexBreaktimeFactor: Double = 3
    @AppStorage("fixedFocusLimit") private var fixedFocusLimit: Int = 25
    @AppStorage("fixedBreakLimit") private var fixedBreakLimit: Int = 5
    
    @State private var sessionIsInProgress = false
    @State private var viewModel = SessionController()
    @State private var todaysFinishedSessions: [SessionSnapshot] = []
    
    @State private var showNewTaskModal: Bool = false
    @State private var today: Date = .now
    
    private let sessionFactory = SessionFactory()
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                TodayOverview(todaysSessions: todaysFinishedSessions)
                TodayTimeDistribution(todaysSessions: todaysFinishedSessions)
                TodayGoalList(todaysSessions: todaysFinishedSessions)
            }
            .padding()
        }
        .opacity(showNewTaskModal ? 0.5 : 1)
        .blur(radius: showNewTaskModal ? 1.5 : 0)
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            AddNewSession(showNewTaskModal: $showNewTaskModal)
        }
        .sheet(isPresented: $showNewTaskModal, onDismiss: {
            guard viewModel.state == .PREPARING else { return }
            viewModel.reset()
        }) {
            AddNewSessionSheet(
                sessionGoal: $viewModel.goal,
                flexSettings: (
                    flexBreaktimeLimit,
                    flexBreaktimeFactor
                ),
                fixedSettings: (
                    fixedFocusLimit,
                    fixedBreakLimit
                )
            ) {
                selectedVariant in
                
                startSession(variant: selectedVariant)
            }
            .presentationDetents([.medium])
            .presentationCornerRadius(24)
        }
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text(today, format: .dateTime.day().month().year())
                    .foregroundStyle(.secondary)
            }
        }
        .navigationDestination(isPresented: $sessionIsInProgress) {
            sessionFactory.createSessionView(with: viewModel.session, goal: viewModel.goal)
                .navigationBarBackButtonHidden()
                .toolbar(.hidden, for: .tabBar)
        }
        .task(id: today) {
            await fetchTodaysSessions()
        }
        .task {
            await restoreRunningSession()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            guard oldValue == .inactive && newValue == .active else { return }
            guard !Calendar.current.isDateInToday(today) else { return }
            
            today = .now
        }
        .onChange(of: sessionIsInProgress) { oldValue, newValue in
            if oldValue == true && newValue == false {
                finishSession()
            }
        }
    }
    
    private func startSession(variant: SessionType) {
        let sessionConfiguration = createSessionConfiguration(for: variant)
        viewModel.start(with: sessionConfiguration)
        
        if persistenceManager != nil {
            Task {
                try await persistenceManager?.insertSession(from: viewModel, configuration: sessionConfiguration)
            }
        }
        viewModel.session.next(onFinishingSegment: nil)
        
        sessionIsInProgress = true
        showNewTaskModal = false
    }
    
    private func createSessionConfiguration(for variant: SessionType) -> SessionConfiguration {
        let focusTimeLimit = variant == .fixed ? fixedFocusLimit : 0
        let breakTimeLimit = variant == .fixed ? fixedBreakLimit : flexBreaktimeLimit
        
        return SessionConfiguration(type: variant,
                                    focustimeLimit: focusTimeLimit,
                                    breaktimeLimit: breakTimeLimit,
                                    breaktimeFactor: flexBreaktimeFactor)
    }
    
    private func finishSession() {
        viewModel.finish()
        Task {
            try? await persistenceManager?.finishSession(with: viewModel.session)
            
            viewModel.reset()
            
            todaysFinishedSessions = await persistenceManager?.getFinishedSessions(for: today) ?? []
        }
    }
    
    private func fetchTodaysSessions() async {
        todaysFinishedSessions = await persistenceManager?.getFinishedSessions(for: today) ?? []
    }
    
    private func restoreRunningSession() async {
        // Only try to restore if we are currently in preparing phase
        guard viewModel.state == .PREPARING else { return }
        
        let unfinished = await persistenceManager?.getLatestRunningSession() ?? nil
        guard let unfinished else { return }
        
        let restored = await restorationManager?.restoreSessions(from: unfinished) {
            untracked in
            try? await persistenceManager?.updateSession(with: untracked)
        }
        guard let restored else { return }
        
        viewModel.restore(state: restored.state,
                          goal: restored.goal,
                          started: restored.started,
                          session: restored.session)
        
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
    .environment(\.restorationManager, RestorationManager())
    .environment(NotificationManager(notificationService: NotificationServiceMock()))
}
