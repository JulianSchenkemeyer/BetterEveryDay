//
//  NotificationService.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications

/// Defines the functionality provided by the NotificationService
protocol NotificationServiceProtocol {
    /// Schedule a new notification
    /// - Parameter notification: Notification, which will be scheduled
    func schedule(notification: any BEDNotification)
    /// Remove a specific notification
    /// - Parameter notification: Notification to be removed
    func remove(notification: any BEDNotification)
    /// Remove all delivered notifications, so they are no longer displayed in the NotificationCenter
    func removeDeliveredNotifications()
    /// Remove all pending notifications
    func removePendingNotifications()
}

/// NotificationService for local notifications
final class NotificationService: NotificationServiceProtocol {
    var notificationCenter: UNUserNotificationCenter
    
    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func schedule(notification: any BEDNotification) {
        let id = notification.id
        let content = notification.content
        let trigger = notification.trigger
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    func remove(notification: any BEDNotification) {
        let id = notification.id
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func removeDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    func removePendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}

/// Mock implementation for the NotificationService
final class NotificationServiceMock: NotificationServiceProtocol {
    init() { }
    
    func schedule(notification: any BEDNotification) { }
    
    func remove(notification: any BEDNotification) { }
    
    func removeDeliveredNotifications() { }
    
    func removePendingNotifications() { }
}
