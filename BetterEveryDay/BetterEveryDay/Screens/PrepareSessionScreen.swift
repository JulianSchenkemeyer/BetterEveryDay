//
//  SwiftUIView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 17.03.24.
//

import SwiftUI

struct PrepareSessionScreen: View {
    @State private var goal = ""
    @State private var sessionIsInProgress = false
    
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
            
            Spacer()
            
            VStack(spacing: 30) {
                TextField("Your Goal for the Session", text: $goal)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3)
                    .minimumScaleFactor(0.7)
                .foregroundStyle(.black, .red)
                
                Button {
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
        .sheet(isPresented: $sessionIsInProgress, content: {
//            Text("In Progress")
//                .font(.largeTitle)
            SessionScreen()
        })
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
    
}
