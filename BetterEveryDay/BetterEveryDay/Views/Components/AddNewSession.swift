//
//  AddNewSession.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 24.10.24.
//

import SwiftUI

struct AddNewSession: View {
    @Binding var sessionGoal: String
    @Binding var showNewTaskModal: Bool
    
    @FocusState private var focusSessionGoalInput: Bool
    
    var onStartSession: () -> Void
    
    
    var body: some View {
        Group {
            if showNewTaskModal {
                HStack {
                    TextField("Your Goal for the Session",
                              text: $sessionGoal,
                              axis: .vertical)
                    .lineLimit(1...)
                    .font(.body)
                    .focused($focusSessionGoalInput)
                    .padding([.leading, .vertical], 10)
                    
                    Button("Cancel") {
                        cancelSessionCreation()
                    }
                    .secondaryButtonStyle()
                    .padding(.trailing, 4)
                }
                .padding(4)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.5), radius: 1, x: -1, y: -1)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 3, y: 3 )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
                }
                .padding(.bottom, 32)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Start Session") {
                            startCreatedSession()
                        }
                        .primaryButtonStyle()
                    }
                }
                
            } else {
                Button {
                    showNewTaskModal = true
                    focusSessionGoalInput = true
                } label: {
                    Image(systemName: "plus")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .frame(width: 50, height: 50)
                        .background(.primary)
                        .clipShape(.circle)
                }
                .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3 )
                .padding()
            }
        }
        .padding()
    }
    
    private func cancelSessionCreation() {
        focusSessionGoalInput = false
        sessionGoal = ""
        showNewTaskModal = false
    }
    
    private func startCreatedSession() {
        onStartSession()
    }
}


#Preview {
    AddNewSession(sessionGoal: .constant(""), showNewTaskModal: .constant(true)) { }
    AddNewSession(sessionGoal: .constant(""), showNewTaskModal: .constant(false)) { }
}
