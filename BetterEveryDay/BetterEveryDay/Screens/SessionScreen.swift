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
    @State private var goneOvertime = false
    
    var goal: String
    var viewModel: Session
    
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
                
                if let segment = viewModel.getCurrent() {
                    VStack {
                        if segment.category == .Focus {
                            TimerLabelView(date: segment.startedAt)
                        } else {
                            TimerLabelView(date: segment.startedAt + viewModel.availableBreak)
                                .foregroundStyle(goneOvertime ? .red : .black)
                                .task {
                                    if viewModel.availableBreak > 0 {
                                        try? await waitFor(seconds: viewModel.availableBreak)
                                    }
                                    goneOvertime = true
                                }
                        }
                        Text(segment.category.rawValue)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .tracking(1.1)
                            .fontWeight(.semibold)
                    }
                    
                    
                    Button {
                        viewModel.next()
                        if segment.category == .Focus {
                            goneOvertime = false
                        }
                    } label: {
                        Text(segment.category == .Focus ? "Pause" : "Focus")
                    }
                    .primaryButtonStyle()
                    .padding(.top, 80)
                }
                
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
            SessionScreen(goal: "work on session screen work on session screen",
                          viewModel: Session(segments: [.init(category: .Focus, startedAt: .now)]))
        }
}
