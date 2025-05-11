//
//  BEDNotification.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications

protocol BEDNotification: Identifiable {
    var id: String { get }
    
    var title: String { get set }
    var subtitle: String { get set }
    var body: String { get set }
    
    var triggeredAt: Date { get set }
}

extension BEDNotification {
    var content: UNNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.subtitle = subtitle
        notification.body = body
        notification.sound = UNNotificationSound.default
        
        return notification
    }
    
    var trigger: UNCalendarNotificationTrigger {
        let components = Calendar.current.dateComponents([.day, .month , .year, .hour, .minute, .second], from: triggeredAt)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
}
