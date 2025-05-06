//
//  AddNewSession.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 24.10.24.
//

import SwiftUI


struct AddNewSession: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showNewTaskModal: Bool
    
    var body: some View {
        Button {
            showNewTaskModal = true
        } label: {
            Image(systemName: "plus")
                .bold()
                .foregroundStyle(.white)
                .padding()
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(.primary)
                        .defaultShadow()
                )
        }
    }
}


#Preview {
    AddNewSession(showNewTaskModal: .constant(true))
}
