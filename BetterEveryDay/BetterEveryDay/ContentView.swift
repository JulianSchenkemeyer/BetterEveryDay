//
//  ContentView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject private var notificationManager = EnvironmentManager.setupNotifications()
    @AppStorage("breaktimeLimit") private var breaktimeLimit: Int = 0
    
    var body: some View {
        
        TabView {
            NavigationStack {
                ThirdTimeView(breaktimeLimit: $breaktimeLimit)
                    .navigationTitle("Session")
            }
            .tabItem {
                Label("Timer", systemImage: "house")
            }
            NavigationStack {
                SettingsView(selectedLimit: $breaktimeLimit)
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .environmentObject(notificationManager)
    }
}

enum EnvironmentManager {
    static func setupNotifications() -> NotificationManager {
        let service = NotificationService(notificationCenter: .current())
        return NotificationManager(notificationService: service)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
