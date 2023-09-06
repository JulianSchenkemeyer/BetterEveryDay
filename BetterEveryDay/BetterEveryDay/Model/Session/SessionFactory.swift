//
//  SessionFactory.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.09.23.
//

import Foundation


struct SessionFactory {
    
    func createSession(withLimit : Bool) -> SessionProtocol {
        if withLimit {
            return SessionWithLimit(breakLimit: 10.0)
        }
        
        return SessionWithoutLimit()
    }
}
