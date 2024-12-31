//
//  SessionState.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 04.09.23.
//

import Foundation


public enum SessionState: String, Codable {
    case PREPARING = "Preparing"
    case RUNNING = "Running"
    case FINISHED = "Finished"
}
