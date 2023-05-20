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

	@Published var time = Date()


	func start() {
		timerSubscription = timer.assign(to: \.time, on: self)
	}

	func stop() {
		timerSubscription = nil
	}
}

struct ContentView: View {
	@ObservedObject var viewModel: TimerViewModel = TimerViewModel()

	var body: some View {
		VStack {
			Text(viewModel.time.formatted(.dateTime.minute(.twoDigits).second(.twoDigits)))

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
