//
//  AddNewSessionSheet.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 22.03.25.
//

import SwiftUI


struct AddNewSessionSheet: View {
    var body: some View {
        Text("Add New Session")
    }
}


#Preview {
    Text("Preview")
        .sheet(isPresented: .constant(true)) {
            AddNewSessionSheet()
                .presentationDetents([.medium])
        }
    
}
