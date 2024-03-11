//
//  FocusSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct FocusSessionView: View {
    @Binding var state: ThirdTimeState
    var start: PhaseTimerProtocol?
    
    var body: some View {
        VStack(spacing: 200) {
            if let start {
                TimerLabelView(date: start.start)
                    .background(
                        BackgroundElement(size: 300)
                    )
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
            start: FocusPhaseTimer(start: .now))
    }
}
