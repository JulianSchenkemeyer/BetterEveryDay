//
//  ContentView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI


struct ContentView: View {
#if os(macOS)
    @State private var selected = "timer"
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(selection: $selected) {
                Label("Timer", systemImage: "clock")
                    .tag("timer")
                
                Label("Settings", systemImage: "gear")
                    .tag("settings")
            }
        }, detail: {
            switch true {
            case selected == "timer":
                ThirdTimeView()
            case selected == "settings":
                SettingsView()
            default:
                Text("Please select a view")
            }
        })
        .navigationTitle("Better Every Day")
    }
#else
    var body: some View {
        TabView {
            NavigationStack {
                ThirdTimeView()
            }
            .tabItem {
                Label("Timer", systemImage: "clock")
            }
            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
#endif
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
