//
//  ContentView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI


struct ContentView: View {

	var body: some View {
		NavigationStack {
			TimerView()
				.navigationTitle("Timer")
				.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
