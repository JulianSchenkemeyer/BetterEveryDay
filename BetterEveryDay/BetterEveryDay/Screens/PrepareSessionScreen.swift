//
//  SwiftUIView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 17.03.24.
//

import SwiftUI

struct PrepareSessionScreen: View {
    @EnvironmentObject var persistenceManager: SwiftDataPersistenceManager
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
                    viewModel.session = Session(breaktimeLimit: breaktimeLimit, breaktimeFactor: breaktimeFactor)
                    persistenceManager.insertSession(from: viewModel)
                    
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
            persistenceManager.finishSession(with: viewModel.session)
            viewModel.session = Session(breaktimeLimit: breaktimeLimit, breaktimeFactor: breaktimeFactor)
        }, content: {
            SessionScreen(goal: viewModel.goal, viewModel: viewModel.session)
        })
        .onAppear {
            let unfinished = persistenceManager.getLatestRunningSession()
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
    .environmentObject(PersistenceManagerMock())
}
