//
//  PauseSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct PauseSessionView: View {
    @State private var breakIsOverdrawn = false
    
    @Binding var state: ThirdTimeState
    var start: PhaseTimer?

    
    
    var body: some View {
        VStack {
            Text("PAUSE")
                .modifier(PhaseLabelModifier())
                .foregroundColor(breakIsOverdrawn ? .red : .primary)
            
            if let start {
                TimerLabelView(date: start.displayStart)
                    .foregroundColor(breakIsOverdrawn ? .red : .primary)
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
        .task(goIntoOvertime)
    }
    
    @Sendable private func goIntoOvertime() async {
        guard let start else { return }
        let seconds = start.displayStart.timeIntervalSince1970 - Date.now.timeIntervalSince1970
        
        guard seconds > 0 else {
            breakIsOverdrawn = true
            return
        }
        
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        breakIsOverdrawn = true
    }
}

struct PauseSessionView_Previews: PreviewProvider {
    static var previews: some View {
        PauseSessionView(state: .constant(.Pause),
                         start: PhaseTimer(displayStart: .now))
    }
}
