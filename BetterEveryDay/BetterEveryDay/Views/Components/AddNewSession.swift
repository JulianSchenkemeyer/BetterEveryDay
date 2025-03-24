//
//  AddNewSession.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 24.10.24.
//

import SwiftUI


struct AddNewSession: View {
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
                .background(.primary)
                .clipShape(.circle)
        }
        .shadow(color: .black.opacity(0.5), radius: 1, x: 1, y: 1)
        .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3 )
        .padding(20)
    }
}


#Preview {
    AddNewSession(showNewTaskModal: .constant(true))
}
