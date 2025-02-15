//
//  NotificationHelper.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications



/// A helper class for managing notification permissions.
final class NotificationHelper {
    
    /// Checks the current notification permission status.
    /// - Returns: A Boolean value indicating whether notifications are authorized.
    static func checkNotificationPermissionStatus() async -> Bool {
        guard let status = try? await UNUserNotificationCenter.current().requestAuthorization() else {
            return false
        }
        return status
    }
    
    /// Requests notification permission from the user.
    /// - Throws: An error if the request fails.
    /// - Returns: A Boolean value indicating whether the permission was granted.
    static func requestNofificationPermission() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    }
}

