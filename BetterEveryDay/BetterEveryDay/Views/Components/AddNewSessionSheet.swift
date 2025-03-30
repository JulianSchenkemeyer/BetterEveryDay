//
//  AddNewSessionSheet.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 22.03.25.
//

import SwiftUI


struct AddNewSessionSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedSessionVariant: SessionType = .flexible
    @FocusState private var focusSessionGoalInput: Bool
    
    @Binding var sessionGoal: String
    var onStartSession: (SessionType) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Session Type", selection: $selectedSessionVariant) {
                    Text("Flexible").tag(SessionType.flexible)
                    Text("Fixed").tag(SessionType.fixed)
                }
                .pickerStyle(.segmented)
                
                Divider()
                
                HStack {
                    TextField("Your Goal for the Session",
                              text: $sessionGoal,
                              axis: .vertical)
                    .lineLimit(1...3)
                    .font(.body)
                    .focused($focusSessionGoalInput)
                    .padding(.vertical, 10)
                }
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 10)
            .contentShape(Rectangle())
            .onTapGesture {
                focusSessionGoalInput = true
            }
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                Button {
                    onStartSession(selectedSessionVariant)
                    dismiss()
                } label: {
                    Text("Start")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                        .background(.primary)
                        .clipShape(.capsule)
                }
                .defaultShadow()
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 24))
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("New Session")
                        .font(.headline)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .padding(4)
            .onAppear {
                focusSessionGoalInput = true
            }
        }
    }
}


#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            AddNewSessionSheet(sessionGoal: .constant(""),
                               onStartSession: {_ in })
            .presentationDetents([.medium])
        }
    
}
