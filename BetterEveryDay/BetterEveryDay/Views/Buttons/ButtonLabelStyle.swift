//
//  ButtonLabelStyle.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 23.06.23.
//

import SwiftUI

struct ButtonLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .font(.body)
            .fontWeight(.semibold)
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
}

struct ButtonLabelStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            
        } label: {
            Label("Home", systemImage: "house")
        }
        .labelStyle(ButtonLabelStyle())
        .buttonStyle(.bordered)
    }
}
