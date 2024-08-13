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
                
                
                VStack {
                    if let segment = viewModel.segments.last {
                        TimerLabelView(date: segment.startedAt)
                        Text(segment.category.rawValue)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .tracking(1.1)
                            .fontWeight(.semibold)
                    }
                }
                
                
                Button {
                    viewModel.next()
                } label: {
                    Text(viewModel.segments.last?.category.rawValue ?? "")
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
