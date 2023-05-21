//
//  TimerView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 21.05.23.
//

import SwiftUI

struct TimerView: View {
	@ObservedObject var viewModel: TimerViewModel = TimerViewModel(timeLeftInSeconds: 10)

	var body: some View {
		VStack {
			Text("\(viewModel.countdown)")

			Button {
				viewModel.start()
			} label: {
				Text("start")
			}
			.padding()

			Button {
				viewModel.stop()
			} label: {
				Text("stop")
			}
			.padding()

			Button {
				viewModel.reset(timeLeftInSeconds: 10)
			} label: {
				Text("reset")
			}
			.padding()

		}
	}
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
