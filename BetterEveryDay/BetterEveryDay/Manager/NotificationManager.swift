//
//  NotificationManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications

protocol NotificationManagerProtocol {
    var notificationService: NotificationServiceProtocol { get }
    var scheduledNotifications: [any BEDNotification] { get set }
    
    func schedule(notification: any BEDNotification)
    
    func removeScheduledNotifications()
}

final class NotificationManager: NotificationManagerProtocol {
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
        for scheduledNotification in scheduledNotifications {
            notificationService.remove(notification: scheduledNotification)
        }
        scheduledNotifications = []
    }
}
