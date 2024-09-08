//
//  Card.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 07.09.24.
//

import SwiftUI

struct Card<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            content()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 1, y: 1)
                .shadow(color: .white.opacity(0.3), radius: 2, x: -1, y: -1)
        }
    }
}

#Preview {
    Card {
        Text("This is a card component")
    }
}
