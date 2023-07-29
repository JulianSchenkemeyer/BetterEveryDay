//
//  TimeSpendData.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 26.07.23.
//

import Foundation

struct TimeSpendData: Identifiable {
    let id = UUID()
    
    let part: Double
    let category: String
}
