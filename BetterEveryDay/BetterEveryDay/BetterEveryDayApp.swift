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
    private var notificationManager = EnvironmentManager.setupNotifications()
    private var persistenceManager = EnvironmentManager.setupPersistenceManager()
    private var restorationManager = EnvironmentManager.setupRestorationManager()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(persistenceManager.modelContainer)
        .environment(notificationManager)
        .environment(\.persistenceManager, persistenceManager)
        .environment(\.restorationManager, restorationManager)
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
    
    @MainActor static func setupRestorationManager() -> RestorationManager {
        RestorationManager()
    }
}
