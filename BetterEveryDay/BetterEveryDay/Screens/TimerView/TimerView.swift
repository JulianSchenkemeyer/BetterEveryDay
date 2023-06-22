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
		VStack(spacing: 50) {

			ZStack {
				Text(
					Duration
						.seconds(viewModel.countdown),
					format:
							.time(pattern: .hourMinuteSecond))
					.font(.title)
					.bold()
			}


			Button {
				viewModel.start()
			} label: {
				Label("Start", systemImage: "play.fill")
					.font(.title3.bold())
					.frame(width: 200, height: 44)
			}
			.buttonStyle(.borderedProminent)
			.buttonBorderShape(.capsule)
			.tint(.cyan)
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
