//
//  NotificationService.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    var notificationCenter: UNUserNotificationCenter { get }
    
    func schedule(notification: any BEDNotification)
    func remove(notification: any BEDNotification)
    func removeDeliveredNotifications()
}

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
}
