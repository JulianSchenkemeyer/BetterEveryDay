//
//  ThirdTimeView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.06.23.
//

import SwiftUI

enum ThirdTimeState {
    case FocusSession, PauseSession, PrepareSession, ReflectSession
}

final class ThirdTimeViewModel: ObservableObject {
    @Published var timerStart = Date.now
    @Published var totalFocusLength = 0.0
    @Published var totalBreakLength = 0.0
    
    var lengthOfLastFocusSession = 0.0
    @Published var availableBreakTime = 0.0
    
    
    @Published var state: ThirdTimeState = .PrepareSession {
        didSet {
            switch state {
            case .FocusSession:
                totalBreakLength = calculateTimeProgressed()
                timerStart = continuePreviousTimer(with: totalFocusLength)
                
            case .PauseSession:
                totalFocusLength = calculateTimeProgressed()
                timerStart = Date.now
                
            case .ReflectSession:
                totalBreakLength = 0.0
                totalFocusLength = 0.0
            default:
                break
            }
        }
    }
    
    private func calculateTimeProgressed() -> Double {
        Date.now.timeIntervalSince1970 - timerStart.timeIntervalSince1970
    }
    
    private func continuePreviousTimer(with offset: Double) -> Date {
        let modifiedStartDate = Date.now.timeIntervalSince1970 - offset
        print("continue from \(modifiedStartDate)")
        
        return Date(timeIntervalSince1970: offset)
    }
    
    private func calculateMaxBreakTime() {
        
    }
}

struct ThirdTimeView: View {
    
    @StateObject private var viewModel = ThirdTimeViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .PrepareSession:
                PrepareSessionView(state: $viewModel.state)
            case .FocusSession:
                FocusSessionView(state: $viewModel.state,
                                 start: $viewModel.timerStart)
            case .PauseSession:
                PauseSessionView(state: $viewModel.state,
                                 start: $viewModel.timerStart)
            case .ReflectSession:
                ReflectSessionView(state: $viewModel.state)
                    .onAppear {
                        viewModel.timerStart = .now
                    }
            }
        }
    }
    
//    private func goingIntoPauseOvertime(in seconds: Int) async {
//        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
//        pauseIsOver = true
//        print("overtime")
//    }
//
//    func calculatePause(for date: Date) -> Date {
//        let lengthOfFocusSession = Date.now.timeIntervalSince1970 - marker.timeIntervalSince1970
//
//        let maxPauseLength = Int(lengthOfFocusSession / 3)
//
//        Task {
//            await goingIntoPauseOvertime(in: maxPauseLength)
//        }
//
//        return Calendar.current.date(byAdding: .second, value: maxPauseLength, to: Date.now)!
//    }
}

struct ThirdTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdTimeView()
    }
}
