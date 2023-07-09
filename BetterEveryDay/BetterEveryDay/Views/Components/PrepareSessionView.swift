//
//  PrepareSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct PrepareSessionView: View {
    @Binding var state: ThirdTimeState
    
    var body: some View {
        VStack {
            Text("PREPARE")
                .modifier(PhaseLabelModifier())
            
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
        PrepareSessionView(state: .constant(.Prepare))
    }
}
