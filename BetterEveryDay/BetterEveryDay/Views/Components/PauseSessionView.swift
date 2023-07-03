//
//  PauseSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct PauseSessionView: View {
    @Binding var state: ThirdTimeState
    @Binding var start: Date
    @Binding var breakIsOverdrawn: Bool
    
    var body: some View {
        VStack {
            Text("PAUSE")
                .modifier(PhaseLabelModifier())
                .foregroundColor(breakIsOverdrawn ? .red : .primary)
            
            TimerLabelView(date: start)
                .foregroundColor(breakIsOverdrawn ? .red : .primary)
            
            HStack {
                Button {
                    state = .FocusSession
                } label: {
                    Label("Continue", systemImage: "play")
                }
                .primaryButtonStyle()
                
                Button {
                    state = .ReflectSession
                } label: {
                    Label("Finish", systemImage: "stop.fill")
                }
                .secondaryButtonStyle()
            }
        }
    }
}

struct PauseSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PauseSessionView(state: .constant(.PauseSession),
                         start: .constant(.now),
                         breakIsOverdrawn: .constant(false))
    }
}
