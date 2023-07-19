//
//  FocusSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct FocusSessionView: View {
    @Binding var state: ThirdTimeState
    var start: PhaseTimer?
    
    var body: some View {
        VStack {
            Text("FOCUS")
                .modifier(PhaseLabelModifier())
            if let start {
                TimerLabelView(date: start.displayStart)
            }
            
            HStack {
                Button {
                    state = .Pause
                } label: {
                    Label("Pause", systemImage: "pause")
                }
                .primaryButtonStyle()
                
                Button {
                    state = .Reflect
                } label: {
                    Label("Finish", systemImage: "stop.fill")
                }
                .secondaryButtonStyle()
            }
        }
    }
}

struct FocusSessionView_Previews: PreviewProvider {
    static var previews: some View {
        FocusSessionView(
            state: .constant(.Focus),
            start: PhaseTimer(displayStart: .now))
    }
}
