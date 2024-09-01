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
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.ultraThinMaterial)
                    .frame(height: 250)
                .padding(.top, 30)
                
                VStack(alignment: .leading) {
                    Text("Today")
                        .font(.title3)
                        .bold()
                }
            }
            
            
            VStack(spacing: 30) {
                TextField("Your Goal for the Session",
                          text: $viewModel.goal,
                          axis: .vertical)
                    .lineLimit(1...)
                    .textFieldStyle(.roundedBorder)
                    .font(.body)
                    .submitLabel(.go)

                
                Button {
                    viewModel.state = .RUNNING
                    viewModel.session = Session(breaktimeLimit: breaktimeLimit, breaktimeFactor: breaktimeFactor)
                    if persistenceManager != nil {
                        persistenceManager?.insertSession(from: viewModel)
                    }
                    viewModel.session.next()
                    sessionIsInProgress = true
                } label: {
                    Label("Start Session", systemImage: "play")
                }
                .primaryButtonStyle()
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 100)
        .navigationTitle("Prepare")
        .navigationBarTitleDisplayMode(.automatic)
        .fullScreenCover(isPresented: $sessionIsInProgress, onDismiss: {
            viewModel.state = .FINISHED
            viewModel.goal = ""
            
            persistenceManager?.finishSession(with: viewModel.session)
            
            viewModel.session = Session(breaktimeLimit: breaktimeLimit, breaktimeFactor: breaktimeFactor)
        }, content: {
            SessionScreen(goal: viewModel.goal, viewModel: viewModel.session)
        })
        .onAppear {
            let unfinished = persistenceManager?.getLatestRunningSession() ?? nil
            guard let unfinished else { return }
            viewModel = unfinished
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
//    .environment(\.persistenceManager, PersistenceManagerMock())
    .environment(NotificationManager(notificationService: NotificationServiceMock()))
}
