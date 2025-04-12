//
//  SessionConfigurationInfo.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 12.04.25.
//
import SwiftUI


struct SessionConfigurationInfoView: View {
    var selectedSessionVariant: SessionType
    
    var flexSettings: (limit: Int, factor: Double) = (0, 0)
    var fixedSettings: (focus: Int, pause: Int) = (0, 0)
    
    var body: some View {
        VStack(alignment: .leading) {
            switch selectedSessionVariant {
            case .fixed:
                Text("Focus: \(fixedSettings.focus) minutes")
                Text("Pause: \(fixedSettings.pause) minutes")
            case .flexible:
                Text("Faktor: x / \(flexSettings.factor, format: .number)")
                Text(flexSettings.limit > 0 ? "Limit: \(flexSettings.limit / 60) minutes" : "")
            }
        }
        .font(.caption)
        .fontWeight(.semibold)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .padding(EdgeInsets(top: 10, leading: 32, bottom: 10, trailing: 32))
        .background(.thickMaterial)
        .clipShape(.capsule)
    }
}


#Preview("Fixed") {
    SessionConfigurationInfoView(selectedSessionVariant: .fixed, fixedSettings:(focus: 25, pause: 5))
}

#Preview("Flexible") {
    SessionConfigurationInfoView(selectedSessionVariant: .flexible, flexSettings: (limit: 150, factor: 1.25))
}

