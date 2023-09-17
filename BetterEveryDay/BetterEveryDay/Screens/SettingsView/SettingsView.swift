//
//  SettingsView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.09.23.
//

import SwiftUI

struct SettingsView: View {
    
    let limits = [0, 3, 4, 5, 6, 7, 8, 9, 10]
    @State var selectedLimit = 3
    
    var body: some View {
        Form {
            Section {
                
                Picker("Options for Limit", selection: $selectedLimit) {
                    ForEach(limits, id: \.self) {
                        LimitOptionsLabel(value: $0)
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
        SettingsView()
    }
}
