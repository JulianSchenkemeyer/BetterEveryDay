//
//  CountdownView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 21.05.23.
//

import SwiftUI

struct WatchProgressStyle: ProgressViewStyle {
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
		}
	}
}

struct CountdownView: View {
	@Binding var progress: Int
	var frame: CGFloat = .infinity

    var body: some View {
		ZStack {
			ProgressView(
				"test",
				value: Double(progress),
				total: 10
			)
				.progressViewStyle(
					WatchProgressStyle()
				)
				.padding()
				.frame(width: frame, height: frame)

			Text("\(progress)")
				.font(.title)
				.bold()
		}
    }

	func convertToPercent(_ progress: Int) -> Double {
		return Double(progress)
	}
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
		CountdownView(progress: .constant(10))
    }
}
