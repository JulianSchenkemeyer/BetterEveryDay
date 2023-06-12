//
//  CountdownView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 21.05.23.
//

import SwiftUI

struct CountdownView: View {
	@Binding var progress: Int
	var endValue: Int
	var frame: CGFloat = .infinity

    var body: some View {
		ZStack {
			ProgressView(
				"Timer Progress",
				value: Double(progress),
				total: Double(endValue)
			)
				.progressViewStyle(
					CircleProgressStyle(tint: .cyan)
				)
				.padding()
				.frame(width: frame, height: frame)
		}
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
		CountdownView(progress: .constant(10), endValue: 10)
    }
}
