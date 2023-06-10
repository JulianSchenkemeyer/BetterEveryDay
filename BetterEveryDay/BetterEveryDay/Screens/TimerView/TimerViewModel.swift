//
//  TimerViewModel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 21.05.23.
//

import Foundation
import Combine

class TimerViewModel: ObservableObject {
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	private var timerSubscription: Cancellable?

	private var startingDate = Date()
	var initialTimeLeft: Int
	private var timeLeftInSeconds: Int
	private var timerIsRunning = false

	@Published var countdown: Int {
		didSet {
			if countdown <= 0 {
				stop()
			}
		}
	}

	init(timeLeftInSeconds: Int) {
		self.initialTimeLeft = timeLeftInSeconds
		self.timeLeftInSeconds = timeLeftInSeconds
		self.countdown = timeLeftInSeconds
	}

	

	func start() {
		guard timeLeftInSeconds > 0 else { return }
		guard !timerIsRunning else { return }

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
		timeLeftInSeconds = countdown
		timerIsRunning = false
	}

	func reset(timeLeftInSeconds: Int) {
		stop()
		self.timeLeftInSeconds = timeLeftInSeconds
		self.countdown = timeLeftInSeconds

		start()
	}
}
