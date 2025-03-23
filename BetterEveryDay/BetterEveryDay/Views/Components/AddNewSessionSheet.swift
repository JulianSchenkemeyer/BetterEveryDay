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
                    .lineLimit(1...)
                    .font(.body)
                    .focused($focusSessionGoalInput)
                    .padding([.leading, .vertical], 10)
                    .padding(.trailing, 4)
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)

            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Start Session") {
                        
                    }
                    .primaryButtonStyle()
                }
            }
            .padding(4)
            .padding(.bottom, 32)
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
