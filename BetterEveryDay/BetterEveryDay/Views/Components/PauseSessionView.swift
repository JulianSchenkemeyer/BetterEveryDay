//
//  PauseSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct PauseSessionView: View {
    @Binding var state: ThirdTimeState
    @Binding var availableBreaktime: TimeInterval
    
    @State private var goneIntoOvertime = false
    
    var start: PhaseTimerProtocol?
    
    var body: some View {
        VStack {
            if let start {
                TimerLabelView(date: start.start)
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
        .task {
            guard availableBreaktime > 0 else {
                self.goneIntoOvertime = true
                return
            }
            try? await waitFor(seconds: availableBreaktime)
            self.goneIntoOvertime = true            
        }
    }
}

struct PauseSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PauseSessionView(state: .constant(.Pause),
                         availableBreaktime: .constant(0.0),
                         start: PhaseTimer(start: .now))
    }
}
