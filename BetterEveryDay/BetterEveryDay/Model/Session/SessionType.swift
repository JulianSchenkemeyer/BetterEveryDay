//
//  SessionType.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.02.25.
//


enum SessionType: String, CaseIterable, Identifiable {
    case fixed, flexible
    
    var id: Self { self }
}
