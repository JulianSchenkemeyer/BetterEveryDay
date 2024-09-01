//
//  EnvironmentValues+Ext.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.09.24.
//

import SwiftUI


private struct PersistenceManagerKey: EnvironmentKey {
    static let defaultValue: any PersistenceManagerProtocol = PersistenceManagerMock()
}

extension EnvironmentValues {
    var persistenceManager: any PersistenceManagerProtocol {
        get { self[PersistenceManagerKey.self] }
        set { self[PersistenceManagerKey.self] = newValue }
    }
}
