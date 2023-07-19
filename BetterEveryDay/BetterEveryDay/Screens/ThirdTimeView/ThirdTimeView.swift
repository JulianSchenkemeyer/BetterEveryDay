//
//  ThirdTimeView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.06.23.
//

import SwiftUI

enum ThirdTimeState {
    case Focus, Pause, Prepare, Reflect
}

struct ThirdTimeView: View {
    
    @StateObject private var viewModel = ThirdTimeViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.phase {
            case .Prepare:
                PrepareSessionView(state: $viewModel.phase)
            case .Focus:
                FocusSessionView(state: $viewModel.phase,
                                 start: viewModel.phaseTimer)
            case .Pause:
                PauseSessionView(state: $viewModel.phase,
                                 start: viewModel.phaseTimer)
            case .Reflect:
                ReflectSessionView(state: $viewModel.phase)
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
