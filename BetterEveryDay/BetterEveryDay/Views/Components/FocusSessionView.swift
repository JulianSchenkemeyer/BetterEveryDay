//
//  FocusSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct FocusSessionView: View {
    @Binding var state: ThirdTimeState
    @Binding var start: Date
    
    var body: some View {
        VStack {
            Text("FOCUS")
                .modifier(PhaseLabelModifier())
            
            TimerLabelView(date: start)
            
            HStack {
                Button {
                    state = .PauseSession
                } label: {
                    Label("Pause", systemImage: "pause")
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

struct FocusSessionView_Previews: PreviewProvider {
    static var previews: some View {
        FocusSessionView(
            state: .constant(.FocusSession),
            start: .constant(.now))
    }
}
