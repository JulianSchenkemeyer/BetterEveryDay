//
//  CountdownView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 21.05.23.
//

import SwiftUI

struct PieProgressStyle: ProgressViewStyle {
	var tint: Color = .accentColor

	func makeBody(configuration: Configuration) -> some View {
		let degrees = configuration.fractionCompleted! * 360

		return PieChartPiece(startAngle: .degrees(degrees), endAngle: .degrees(0))
			.rotation(.degrees(-90))
			.foregroundColor(tint)
	}
}

struct PieChartPiece: Shape {
	var startAngle: Angle
	var endAngle: Angle

	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
					radius: (rect.width / 2) - 20,
					startAngle: startAngle,
					endAngle: endAngle,
					clockwise: false)

		return path.strokedPath(.init(lineWidth: 10))
	}
}

struct CountdownView: View {
	@Binding var progress: Int
	var frame: CGFloat = .infinity

    var body: some View {
		ZStack {
			ProgressView("", value: convertToPercent(progress), total: 10)
				.progressViewStyle(PieProgressStyle(tint: .green))
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
