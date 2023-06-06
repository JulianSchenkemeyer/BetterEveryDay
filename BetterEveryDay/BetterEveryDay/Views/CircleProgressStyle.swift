//
//  CircleProgressStyle.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.06.23.
//

import SwiftUI


struct CircleProgressStyle: ProgressViewStyle {
	var tint: Color = .accentColor

	func makeBody(configuration: Configuration) -> some View {
		let degrees = configuration.fractionCompleted!

		return ZStack {
			Circle()
				.stroke(.gray, lineWidth: 10)
				.shadow(color: .gray, radius: 2)
				.shadow(color: .gray, radius: 6)
				.shadow(color: .gray, radius: 10)
				.opacity(0.2)
				.padding()



			Circle()
				.trim(from: degrees, to: 1)
				.rotation(Angle(degrees: 270))
				.stroke(.blue, lineWidth: 10)
				.shadow(color: .blue, radius: 3)
				.padding()
				.animation(.easeInOut, value: degrees)
		}
	}
}
