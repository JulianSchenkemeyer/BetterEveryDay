//
//  EnvironmentValues+Ext.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.09.24.
//

import SwiftUI


extension EnvironmentValues {
    @Entry var persistenceManager:  (any PersistenceManagerProtocol)?
}
