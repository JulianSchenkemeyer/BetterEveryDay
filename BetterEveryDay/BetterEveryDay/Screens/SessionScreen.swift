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
    
    var viewModel: SessionController
    
    @State private var phase: Phases = .Work
    @State private var date = Date.now
    
    var goal = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    Text("I will...")
                        .foregroundStyle(.secondary)
                    
                    Text(viewModel.goal)
                        
                }
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                .padding(20)
                
                
                VStack {
//                    if let phaseTimer = viewModel.phaseTimer {
//                        TimerLabelView(date: phaseTimer.start)
//                        Text(viewModel.phase.rawValue)
//                            .font(.body)
//                            .foregroundStyle(.secondary)
//                            .tracking(1.1)
//                            .fontWeight(.semibold)
//                    }
                }
                
                
//                Button {
////                    phase = phase == .Pause ? .Work : .Pause
//                    switch viewModel.state {
//                    case .Focus:
//                        viewModel.phase = .Pause
//                    case .Pause:
//                        viewModel.phase = .Focus
//                    default:
//                        break
//                    }
//                } label: {
//                    Text(viewModel.state == .Focus ? "Pause" : "Focus")
//                }
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
        }
    }
}

#Preview {
    Text("test")
        .fullScreenCover(isPresented: .constant(true)) {
            SessionScreen(viewModel: SessionController(state: .RUNNING, goal: "", started: .now), goal: "work on session screen work on session screen")
        }
}
