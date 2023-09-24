//
//  SettingsView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.09.23.
//

import SwiftUI

struct SettingsView: View {
    
    let limits = [0, 180, 240, 300, 360, 420, 480, 540, 600]
    @Binding var selectedLimit: Int
    
    var body: some View {
        Form {
            Section {
                
                Picker("Limit Breaktime", selection: $selectedLimit) {
                    ForEach(limits, id: \.self) {
                        LimitOptionsLabel(value: ($0 / 60))
                    }
                }
                .padding(.vertical, 10)
                    
            } header: {
                Text("Session")
            }
            
            Section {
                RequestNotificationView()
            } header: {
                Text("Permissions")
            }
        }
        .formStyle(.grouped)
    }
}

struct LimitOptionsLabel: View {
    let value: Int
    
    var body: some View {
        Text(value != 0 ? "\(value) Minutes" : "None")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedLimit: .constant(3))
    }
}
