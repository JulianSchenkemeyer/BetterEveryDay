//
//  NotificationHelper.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications


final class NotificationHelper {
    
    static func checkNotificationPermissionStatus() async -> Bool {
        guard let status = try? await UNUserNotificationCenter.current().requestAuthorization() else {
            return false
        }
        return status
    }
    
    static func requestNofificationPermission() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    }
}
