//
//  ThirdTimeView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.06.23.
//

import SwiftUI

enum ThirdTimeState {
    case FocusSession, PauseSession, Initial
}

struct ThirdTimeView: View {
    
    @State private var marker: Date = Date.now
    
    @State private var status: ThirdTimeState = .FocusSession
    @State private var pauseIsOver = false
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 35) {
                Spacer()
                
                description
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                
                
                switch status {
                case .Initial:
                    Text("SET A GOAL")
                        .modifier(PhaseLabelModifier())
                    
                    Text("🤔")
                        .font(.system(size: 80))
                    
//                    BEDButton(label: "Start Session", systemImage: "play") {
//                        status = .FocusSession
//                        marker = Date.now
//                    }

                case .FocusSession:
                    Text("FOCUS")
                        .modifier(PhaseLabelModifier())
                    
                    TimerView(date: marker)
                    
//                    BEDButton(label: "Pause Session", systemImage: "pause") {
//                        status = .PauseSession
//                        marker = calculatePause(for: marker)
//                        pauseIsOver = false
                        
//                    }
                case .PauseSession:
                    Text("PAUSE")
                        .modifier(PhaseLabelModifier())
                        .foregroundColor(pauseIsOver ? .red : .black)
                    
                    TimerView(date: marker)
                        .foregroundColor(pauseIsOver ? .red : .black)
                        
                    
//                    BEDButton(label: "Continue Session", systemImage: "play") {
//                        status = .FocusSession
//                        marker = Date.now
                        

//                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func goingIntoPauseOvertime(in seconds: Int) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
        pauseIsOver = true
        print("overtime")
    }
    
    func calculatePause(for date: Date) -> Date {
        let lengthOfFocusSession = Date.now.timeIntervalSince1970 - marker.timeIntervalSince1970
        
        let maxPauseLength = Int(lengthOfFocusSession / 3)
        
        Task {
            await goingIntoPauseOvertime(in: maxPauseLength)
        }
        
        return Calendar.current.date(byAdding: .second, value: maxPauseLength, to: Date.now)!
    }
    
    var backgroundGradient: some View {
        LinearGradient(
            colors: [.white, .cyan, .cyan, .black],
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
        .opacity(0.65)
        .ignoresSafeArea()
    }
    
    var description: some View {
        VStack(spacing: 10) {
            Text("""
                 Work for as long or as short as you like
                 Break for up to one-third of the time
                 """)
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .frame(width: 320)
            .minimumScaleFactor(0.8)
            .dynamicTypeSize(.xxLarge)
        }
        .padding(15)
    }
}

struct ThirdTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdTimeView()
    }
}
