//
//  BEDButton.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 22.06.23.
//

import SwiftUI

struct SecondaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .labelStyle(ButtonLabelStyle())
            .buttonStyle(.bordered)
    }
}

extension View {
    func secondaryButtonStyle() -> some View {
        modifier(SecondaryButtonModifier())
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Label("Back", systemImage: "arrow.left")
        }
        .secondaryButtonStyle()
    }
}
