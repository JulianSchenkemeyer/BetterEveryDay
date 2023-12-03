//
//  ContentView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject private var notificationManager = EnvironmentManager.setupNotifications()
    
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
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
