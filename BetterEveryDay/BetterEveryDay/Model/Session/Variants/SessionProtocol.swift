//
//  SessionProtocol.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 05.01.25.
//

import Foundation

typealias OnFinishingSegmentClosure = ((TimeInterval, SessionSegment) -> Void)?

protocol SessionProtocol: Observable {
    var type: SessionType { get }
    var segments: [SessionSegment] { get set }
    var availableBreak: TimeInterval { get set }
    
    func getCurrent() -> SessionSegment?
    func next(onFinishingSegment: OnFinishingSegmentClosure)
    func endSession(onFinishingSegment: OnFinishingSegmentClosure)
    
}
