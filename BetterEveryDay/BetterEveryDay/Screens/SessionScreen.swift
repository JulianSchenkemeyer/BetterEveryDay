//
//  SessionScreen.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.03.24.
//

import SwiftUI

enum Phases: String, Codable {
    case Focus, Pause
}

struct SessionScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var phase: Phases = .Focus
    @State private var date = Date.now
    
    var goal = "Work on Session Screen"
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(goal)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                    .padding(20)
                
                
                VStack {
                    TimerLabelView(date: date)
                    Text(phase.rawValue)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .tracking(1.1)
                        .fontWeight(.semibold)
                }
                
                
                Button {
                    phase = .Pause
                } label: {
                    Text("Pause")
                }
                .primaryButtonStyle()
                .padding(.top, 80)
                
                
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Finish")
                    }
                    
                }
            }
            .navigationTitle("Session")
        }
    }
}

#Preview {
    Text("test")
        .sheet(isPresented: .constant(true)) {
            SessionScreen(goal: "1")
        }
}
