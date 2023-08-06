//
//  PauseEndedNotification.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation


struct PauseEndedNotification: BEDNotification {
    var id = UUID().uuidString
    
    var title: String
    var subtitle: String
    var body: String
    
    var triggeredAt: Date
    
    init(triggerAt: Date) {
        self.title = "Time to start focusing again"
        self.subtitle = ""
        self.body = "Your Pause is over, you should get back to your task."
        
        self.triggeredAt = triggerAt
    }
}
