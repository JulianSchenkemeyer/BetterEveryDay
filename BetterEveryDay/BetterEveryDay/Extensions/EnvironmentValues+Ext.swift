//
//  EnvironmentValues+Ext.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.09.24.
//

import SwiftUI
import BetterEveryDayPersistence


extension EnvironmentValues {
    @Entry var persistenceManager:  (any PersistenceManagerProtocol)?
}
