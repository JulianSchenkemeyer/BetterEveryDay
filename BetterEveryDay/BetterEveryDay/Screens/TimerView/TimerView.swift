//
//  TimerView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 21.05.23.
//

import SwiftUI

struct TimerView: View {
	@ObservedObject var viewModel: TimerViewModel

	init(viewModel: TimerViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack {
			CountdownView(progress: $viewModel.countdown,
						  endValue: viewModel.initialTimeLeft,
						  frame: 350)

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

		let vm = TimerViewModel(timeLeftInSeconds: 10)
		NavigationStack {
			TimerView(viewModel: vm)
		}
    }
}
