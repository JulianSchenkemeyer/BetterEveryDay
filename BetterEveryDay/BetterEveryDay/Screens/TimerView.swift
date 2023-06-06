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
			CountdownView(progress: $viewModel.countdown, frame: 350)

			Button {
				viewModel.start()
			} label: {
				Text("start")
					.frame(width: 200, height: 50)
			}
			.buttonStyle(.borderedProminent)
			.buttonBorderShape(.capsule)

			Button {
				viewModel.stop()
			} label: {
				Text("stop")
					.frame(width: 200, height: 50)
			}
			.buttonStyle(.borderedProminent)
			.tint(.red)
			.buttonBorderShape(.capsule)

		}
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					viewModel.reset(timeLeftInSeconds: 10)
				} label: {
					Label("Reset", systemImage: "arrow.counterclockwise")
				}
			}
		}
	}
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			TimerView()
		}
    }
}
