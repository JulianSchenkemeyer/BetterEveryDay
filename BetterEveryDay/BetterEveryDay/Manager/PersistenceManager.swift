//
//  PersistenceManager.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 01.12.23.
//

import Foundation
import SwiftData

protocol PersistenceManagerProtocol: ObservableObject {
    func createNewSession(from sessionController: SessionController)
    func finishRunningSession(with sessionController: SessionController)
    func createNewSessionSegment(form segment: SessionSegment)
    func finishLastSessionSegment()
}

final class PersistenceManagerMock: PersistenceManagerProtocol {
    func createNewSession(from sessionController: SessionController) { }
    func finishRunningSession(with sessionController: SessionController) { }
    func createNewSessionSegment(form segment: SessionSegment) { }
    func finishLastSessionSegment() { }
}

