//
//  PrepareSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct PrepareSessionView: View {
    @Binding var state: ThirdTimeState
    @Binding var goal: String
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("What do you want to work on?", text: $goal,
                      axis: .vertical)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
            
            Button {
                state = .Focus
            } label: {
                Label("Start", systemImage: "play")
            }
            .primaryButtonStyle()
        }
        .padding(.horizontal, 20)
    }
}

struct PrepareSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PrepareSessionView(state: .constant(.Prepare),
                           goal: .constant(""))
    }
}
