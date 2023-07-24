//
//  PrepareSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct PrepareSessionView: View {
    @Binding var state: ThirdTimeState
    @Binding var isLimited: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("PREPARE")
                .modifier(PhaseLabelModifier())
     
            Toggle("limit max pause", isOn: $isLimited)
                .padding(.horizontal, 80)
            
            Button {
                state = .Focus
            } label: {
                Label("Start", systemImage: "play")
            }
            .primaryButtonStyle()
        }
    }
}

struct PrepareSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PrepareSessionView(state: .constant(.Prepare), isLimited: .constant(false))
    }
}
