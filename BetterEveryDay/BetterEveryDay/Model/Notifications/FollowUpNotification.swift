//
//  FollowUpNotification.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 22.02.25.
//
import Foundation

struct FollowUpNotification: BEDNotification {
    var id = UUID().uuidString
    
    var title: String
    var subtitle: String
    var body: String
    
    var triggeredAt: Date
    
    init(triggerAt: Date) {
        self.title = "Your Session is still going ..."
        self.subtitle = ""
        self.body = "Haven't seen you for some time. Are you still working on your goals?"
        
        self.triggeredAt = triggerAt
    }
}
