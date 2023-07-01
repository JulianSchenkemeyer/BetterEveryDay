//
//  ReflectSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct ReflectSessionView: View {
    @Binding var state: ThirdTimeState
    
    var body: some View {
        VStack {
            Text("REFLECT")
                .modifier(PhaseLabelModifier())
            
            Button {
                state = .PrepareSession
            } label: {
                Label("Restart", systemImage: "play")
            }
            .primaryButtonStyle()
        }
    }
}

struct ReflectSessionView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectSessionView(state: .constant(.ReflectSession))
    }
}
