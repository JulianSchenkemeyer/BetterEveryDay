//
//  Date+Ext.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 06.02.24.
//

import Foundation

extension Date {
    func add(timeInterval: TimeInterval) -> Date {
        Date(timeIntervalSince1970: self.timeIntervalSince1970 + timeInterval)
    }
}
