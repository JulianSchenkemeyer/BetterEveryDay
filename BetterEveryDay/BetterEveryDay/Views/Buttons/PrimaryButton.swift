//
//  BEDPrimaryButtonModifier.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 23.06.23.
//

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .labelStyle(ButtonLabelStyle())
            .buttonStyle(.borderedProminent)
    }
}

extension View {
    func primaryButtonStyle() -> some View {
        modifier(PrimaryButtonModifier())
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Label("Home", systemImage: "house")
        }
        .primaryButtonStyle()
    }
}
