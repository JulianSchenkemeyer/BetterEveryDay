//
//  FocusEndedNotification.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 16.02.25.
//
import Foundation

struct FocusEndedNotification: BEDNotification {
    var id = UUID().uuidString
    
    var title: String
    var subtitle: String
    var body: String
    
    var triggeredAt: Date
    
    init(triggerAt: Date) {
        self.title = "Time for a break"
        self.subtitle = ""
        self.body = "Your set focus time is over, lean back and enjoy your break."
        
        self.triggeredAt = triggerAt
    }
}
