//
//  SessionScreen.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.03.24.
//

import SwiftUI

enum Phases: String, Codable {
    case Work, Pause
}

struct SessionScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var phase: Phases = .Work
    @State private var date = Date.now
    
    var goal = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    Text("I will...")
                        .foregroundStyle(.secondary)
                    
                    Text(goal)
                        
                }
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
                    phase = phase == .Pause ? .Work : .Pause
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
//            .navigationTitle("Session")
        }
    }
}

#Preview {
    Text("test")
        .sheet(isPresented: .constant(true)) {
            SessionScreen(goal: "work on session screen work on session screen")
        }
}
