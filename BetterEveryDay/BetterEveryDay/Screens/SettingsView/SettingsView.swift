//
//  SettingsView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.09.23.
//

import SwiftUI

struct SettingsView: View {
    
    let limits = [0, 180, 240, 300, 360, 420, 480, 540, 600]
    @AppStorage("breaktimeLimit") private var breaktimeLimit: Int = 0
    @AppStorage("breaktimeFactor") private var breaktimeFactor = 3.0
    
    var body: some View {
        Form {
            Section {
                Picker("Limit Breaktime", selection: $breaktimeLimit) {
                    ForEach(limits, id: \.self) {
                        LimitOptionsLabel(value: ($0 / 60))
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Factor:")
                    Text("\(breaktimeFactor, format: .number) minutes work for 1 minute pause")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        
                    Slider(value: $breaktimeFactor, in: 1...5, step: 1) {
                        Text("Factor")
                    }
                }
            } header: {
                Text("Session Settings")
            }
            .padding(.vertical, 10)
            
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
