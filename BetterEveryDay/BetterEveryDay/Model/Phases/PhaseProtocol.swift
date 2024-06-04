//
//  PhaseProtocol.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.06.24.
//

import Foundation


protocol PhaseProtocol {
    var start: Date { get }
    
    var length: TimeInterval { get }
    
    init(start: Date)
}
