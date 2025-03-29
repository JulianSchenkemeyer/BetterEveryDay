//
//  DefaultShadow.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 29.03.25.
//

import SwiftUI


struct DefaultShadow: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .shadow(color: colorScheme == .light ? .black.opacity(0.15) : .white.opacity(0.2), radius: 2, x: 1, y: 1)
            .shadow(color: colorScheme == .light ? .black.opacity(0.15) : .white.opacity(0.1), radius: 4, x: 2, y: 2 )
            .shadow(color: colorScheme == .light ? .gray.opacity(0.05) : .gray.opacity(0.05), radius: 1, x: -1, y: -1)
            .shadow(color: colorScheme == .light ? .gray.opacity(0.01) : .gray.opacity(0.01), radius: 2, x: -2, y: -2)
    }
}

extension View {
    public func defaultShadow() -> some View {
        modifier(DefaultShadow())
    }
}
