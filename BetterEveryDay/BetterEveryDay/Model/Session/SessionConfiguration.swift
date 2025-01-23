//
//  SessionConfiguration.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 23.01.25.
//

enum SessionType: String {
    case fixed, flexible
}

struct SessionConfiguration {
    let type: SessionType
    
    let focustimeLimit: Int
    let breaktimeLimit: Int
    
    let breaktimeFactor: Double
}
