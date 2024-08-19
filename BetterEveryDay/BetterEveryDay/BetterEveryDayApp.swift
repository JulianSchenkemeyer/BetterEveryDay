//
//  BetterEveryDayApp.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI
import SwiftData

@main
struct BetterEveryDayApp: App {
    @StateObject private var notificationManager = EnvironmentManager.setupNotifications()
//    @StateObject private var persistenceManager = EnvironmentManager.setupPersistenceManager()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(persistenceManager.modelContainer)
        .environmentObject(notificationManager)
//        .environmentObject(persistenceManager)
    }
}

enum EnvironmentManager {
    @MainActor static func setupNotifications() -> NotificationManager {
        let service = NotificationService(notificationCenter: .current())
        return NotificationManager(notificationService: service)
    }
    
//    @MainActor static func setupPersistenceManager() -> SwiftDataPersistenceManager {
//        SwiftDataPersistenceManager()
//    }
}
