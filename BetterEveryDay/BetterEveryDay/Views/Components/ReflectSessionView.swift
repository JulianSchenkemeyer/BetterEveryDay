//
//  ReflectSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI

struct ReflectSessionView: View {
    @Binding var state: ThirdTimeState
    
    let totalFocusTime: TimeInterval
    let totalBreakTime: TimeInterval
    let restBreakTime: TimeInterval
    
    
    var body: some View {
        VStack(spacing: 40) {
            Text("REFLECT")
                .modifier(PhaseLabelModifier())
            
            TimeSpendView(totalFocusTime: totalFocusTime,
                          totalBreakTime: totalBreakTime,
                          restBreakTime: restBreakTime)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Total Focus Time:")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                    HourMinutesDurationTextView(timeInterval: totalFocusTime)
                }
                
                HStack {
                    Text("Total Break Time:")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                    HourMinutesDurationTextView(timeInterval: totalBreakTime)
                }
                
                HStack {
                    Text("Rest Break Time:")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                    HourMinutesDurationTextView(timeInterval: restBreakTime)
                }
                
            }.padding(.horizontal, 80)
            
            
            Button {
                state = .Prepare
            } label: {
                Label("Restart", systemImage: "play")
            }
            .primaryButtonStyle()
        }
    }
}

struct ReflectSessionView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectSessionView(state: .constant(.Reflect),
                           totalFocusTime: 21.46406602859497,
                           totalBreakTime: 5.301582098007202,
                           restBreakTime: 1.37322195370992)
    }
}
