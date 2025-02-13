//
//  ClassicSessionTests.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 07.01.25.
//
import Testing
@testable import BetterEveryDay


final class ClassicSessionTests {
    @Test func initClassicSession() {
        let session = FixedSession()
        
        #expect(session.availableBreak == 0)
        #expect(session.segments.count == 0)
        #expect(session.focustimeLimit == 0)
        #expect(session.breaktimeLimit == 0)
    }
    
    @Test func initClassicSessionWithParameters() {
        let session = FixedSession(segments: [], focustimeLimit: 30, breaktimeLimit: 10)
        
        #expect(session.segments.isEmpty)
        #expect(session.availableBreak == 0)
        #expect(session.focustimeLimit == 30)
        #expect(session.breaktimeLimit == 10)
    }
    
    @Test func getCurrentSegment() {
        let session = FixedSession()
        
        #expect(session.getCurrent() == nil)
        
        session.next()
        #expect(session.getCurrent() != nil)
        
        session.next()
        #expect(session.getCurrent() != session.segments[0])
        #expect(session.getCurrent() == session.segments[1])
    }
    
    @Test func startClassicSession() {
        let session = FixedSession(segments: [], focustimeLimit: 30, breaktimeLimit: 10)
        session.next()
        
        #expect(session.segments.count == 1)
        #expect(session.availableBreak == 0)
        let segment = session.segments[0]
        #expect(segment.category == .Focus)
        #expect(segment.duration == 30.0 * 60)
    }
    
    @Test func progressThroughClassicSession() {
        let session = FixedSession(segments: [], focustimeLimit: 25, breaktimeLimit: 5)
        session.next()
        
        #expect(session.getCurrent()?.category == .Focus)
        #expect(session.getCurrent()?.duration == (25.0 * 60))
        
        session.next()
        
        #expect(session.getCurrent()?.category == .Pause)
        #expect(session.getCurrent()?.duration == (5.0 * 60))
        
        session.next()
        
        #expect(session.getCurrent()?.category == .Focus)
        #expect(session.getCurrent()?.duration == (25.0 * 60))
    }
    
    @Test func endClassicSession() {
        let session = FixedSession(segments: [], focustimeLimit: 25, breaktimeLimit: 5)
        session.next()
        session.endSession()
        
        #expect(session.segments.count == 1)
        let focusSegment = session.getCurrent()!
        #expect(focusSegment.category == .Focus)
        #expect(focusSegment.duration < 25.0 * 60)
    }
}
