//
//  PauseSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct PauseSessionView: View {
    @Binding var state: ThirdTimeState
    @Binding var goneIntoOvertime: Bool
    
    var start: PhaseTimerProtocol?
    
    var body: some View {
        VStack {
            Text("PAUSE")
                .modifier(PhaseLabelModifier())
                .foregroundColor(goneIntoOvertime ? .red : .primary)
            
            if let start {
                TimerLabelView(date: start.displayStart)
                    .foregroundColor(goneIntoOvertime ? .red : .primary)
            }
            
            HStack {
                Button {
                    state = .Focus
                } label: {
                    Label("Continue", systemImage: "play")
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

struct PauseSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PauseSessionView(state: .constant(.Pause),
                         goneIntoOvertime: .constant(false),
                         start: PhaseTimer(displayStart: .now))
    }
}
