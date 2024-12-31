//
//  BetterEveryDayApp.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI
import SwiftData
import BetterEveryDayPersistence

@main
struct BetterEveryDayApp: App {
    private var notificationManager = EnvironmentManager.setupNotifications()
    private var persistenceManager = EnvironmentManager.setupPersistenceManager()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(persistenceManager.modelContainer)
        .environment(notificationManager)
        .environment(\.persistenceManager, persistenceManager)
    }
}

enum EnvironmentManager {
    static func setupNotifications() -> NotificationManager {
        let service = NotificationService(notificationCenter: .current())
        return NotificationManager(notificationService: service)
    }
    
    static func setupPersistenceManager() -> SwiftDataPersistenceManager {
        SwiftDataPersistenceManager()
    }
}
