//
//  SessionFactory.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.09.23.
//

import Foundation


struct SessionFactory {
    
    func createSession(with limit: TimeInterval) -> SessionProtocol {
        if limit > 0 {
            return SessionWithLimit(breakLimit: limit)
        }
        
        return SessionWithoutLimit()
    }
}
