//
//  CountdownView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 21.05.23.
//

import SwiftUI

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
					CircleProgressStyle()
				)
				.padding()
				.frame(width: frame, height: frame)

			Text("\(progress)")
				.font(.title)
				.bold()
		}
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
		CountdownView(progress: .constant(10))
    }
}
