//
//  BEDNotification.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation
import UserNotifications

protocol BEDNotification: Identifiable {
    var title: String { get set }
    var subtitle: String { get set }
    var body: String { get set }
    
    var triggeredAt: Date { get set }
}

extension BEDNotification {
    func createUNMutableNotificationContent() -> UNNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.subtitle = subtitle
        notification.body = body
        
        return notification
    }
}
