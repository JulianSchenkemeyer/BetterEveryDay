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
    @FocusState private var focusSessionGoalInput: Bool
    
    
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
            Group {
                if showNewTaskModal {
                    HStack {
                        TextField("Your Goal for the Session",
                                  text: $viewModel.goal,
                                  axis: .vertical)
                        .lineLimit(1...)
                        .font(.body)
                        .focused($focusSessionGoalInput)
                        
                        Button("Cancel") {
                            focusSessionGoalInput = false
                            viewModel.goal = ""
                            showNewTaskModal = false
                        }
                    }
                    .padding(16)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.5), radius: 1, x: -1, y: -1)
                            .shadow(color: .black.opacity(0.5), radius: 3, x: 3, y: 3 )
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Start Session") {
                                startSession()
                            }
                        }
                    }
                    
                } else {
                    Button {
                        showNewTaskModal = true
                        focusSessionGoalInput = true
                    } label: {
                        Label("Start Session", systemImage: "play")
                    }
                    .primaryButtonStyle()
                    .padding()
                }
            }
            .padding()
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
        
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            sessionIsInProgress = true
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
