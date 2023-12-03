//
//  BetterEveryDayApp.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI

@main
struct BetterEveryDayApp: App {
    @StateObject private var notificationManager = EnvironmentManager.setupNotifications()
    var body: some Scene {
        WindowGroup {
            ContentView()
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
