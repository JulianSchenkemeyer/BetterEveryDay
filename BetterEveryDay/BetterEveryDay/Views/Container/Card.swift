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
                .defaultShadow()
            
        }
    }
}

#Preview {
    Card {
        Text("This is a card component")
            .frame(height: 300)
    }
    .padding(40)
}
