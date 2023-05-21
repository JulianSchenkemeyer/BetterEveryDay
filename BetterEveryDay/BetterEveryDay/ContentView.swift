//
//  ContentView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	private var timerSubscription: Cancellable?

	private var startingDate = Date()
	private var timeLeftInSeconds: Int

	@Published var countdown: Int {
		didSet {
			print(countdown)
			if countdown <= 0 {
				stop()
			}
		}
	}

	init(timeLeftInSeconds: Int) {
		self.timeLeftInSeconds = timeLeftInSeconds
		self.countdown = timeLeftInSeconds
	}


	func start() {
		startingDate = Date()
		timerSubscription = timer
			.map({ [self] time in
				Int(time.timeIntervalSince1970 - startingDate.timeIntervalSince1970)
			})
			.map({ [self] time in
				self.timeLeftInSeconds - time
			})
			.assign(to: \.countdown, on: self)
	}

	func stop() {
		timerSubscription = nil
	}
}

struct ContentView: View {
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
		}
	}
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//		ContentView(viewModel: <#TimerViewModel#>)
//    }
//}
