//
//  PhaseLabel.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 25.06.23.
//

import SwiftUI

struct PhaseLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
}

struct PhaseLabelModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Phase")
            .modifier(PhaseLabelModifier())
    }
}
