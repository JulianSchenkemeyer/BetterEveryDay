//
//  EnvironmentValues+Ext.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.09.24.
//

import SwiftUI


private struct PersistenceManagerKey: EnvironmentKey {
    static let defaultValue: (any PersistenceManagerProtocol)? = nil
}

extension EnvironmentValues {
    var persistenceManager: (any PersistenceManagerProtocol)? {
        get { self[PersistenceManagerKey.self] }
        set { self[PersistenceManagerKey.self] = newValue }
    }
}
