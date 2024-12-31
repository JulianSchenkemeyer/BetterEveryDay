//
//  Date+Ext.swift
//  BetterEveryDayPersistence
//
//  Created by Julian Schenkemeyer on 31.12.24.
//
import Foundation

extension Date {
    func getStartAndEndOfDay() -> (start: Date, end: Date) {
        let start = Calendar.current.startOfDay(for: self)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: self)!
        let end = Calendar.current.startOfDay(for: tomorrow)
        
        return (start, end)
    }
}
