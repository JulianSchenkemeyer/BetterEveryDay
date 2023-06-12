//
//  ConfigurationView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 10.06.23.
//

import SwiftUI

/*
 TODO: What should be configurable here?
 - Time?
 - What do i what to work on?
 */

struct ConfigurationView: View {

	@State private var goals = ""
	@State private var time = Date()
	@State private var duration = 15
	private var range = Array(stride(from: 5, through: 180, by: 5))

    var body: some View {
		VStack {
			TextEditor(text: $goals)
				.frame(height: 200)
				.overlay {
					RoundedRectangle(cornerRadius: 8)
						.stroke(Color.secondary, lineWidth: 1)
				}



			Picker("How long ", selection: $duration) {
				ForEach(range, id: \.self) { value in
					Text("\(value) minutes").tag(value)
				}
			}
			.pickerStyle(.inline)
			.overlay {
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color.secondary, lineWidth: 1)
			}

			Spacer()

			NavigationLink {
				let durationInSeconds = duration * 60
				let timerVM = TimerViewModel(timeLeftInSeconds: durationInSeconds)
				TimerView(viewModel: timerVM)
			} label: {
				Label("Start Session", systemImage: "play.fill")
					.font(.title3)
					.fontWeight(.semibold)
					.padding()

			}
			.buttonStyle(.borderedProminent)
			.tint(.cyan)
			.buttonBorderShape(.capsule)

		}
		.padding()
		.navigationTitle("New Session")
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationStack {
			ConfigurationView()
		}
    }
}
