//
//  NotificationManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications

/// Defines the functionality of the NotificationManager
protocol NotificationManagerProtocol {
    /// The ``NotificationServiceProtocol`` implementation to be used in the NotificationManager
    var notificationService: NotificationServiceProtocol { get }
    /// Array with the scheduled notifications
    var scheduledNotifications: [any BEDNotification] { get set }
    
    /// Schedule a ``BEDNotification`` notification
    /// - Parameter notification: ``BEDNotification`` to be scheduled
    func schedule(notification: any BEDNotification)
    
    /// Remove all scheduled notifications
    func removeScheduledNotifications()
}

/// NotificationManager Default Implementation
@Observable final class NotificationManager: NotificationManagerProtocol {
    var notificationService: NotificationServiceProtocol
    var scheduledNotifications: [any BEDNotification]
    
    init(notificationService: NotificationServiceProtocol) {
        self.notificationService = notificationService
        self.scheduledNotifications = []
    }
    
    func schedule(notification: any BEDNotification) {
        scheduledNotifications.append(notification)
        notificationService.schedule(notification: notification)
    }
    
    func removeScheduledNotifications() {
        notificationService.removePendingNotifications()
        scheduledNotifications = []
    }
}
