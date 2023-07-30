//
//  PauseEndedNotification.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 30.07.23.
//

import Foundation


struct PauseEndedNotification: BEDNotification {
    var id = UUID()
    
    var title: String
    var subtitle: String
    var body: String
    
    var triggeredAt: Date
}
