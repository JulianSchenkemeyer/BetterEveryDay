//
//  SettingsView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.09.23.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("flexBreaktimeLimit") private var flexBreaktimeLimit: Int = 0
    @AppStorage("flexBreaktimeFactor") private var flexBreaktimeFactor: Double = 3
    @AppStorage("fixedFocusLimit") private var fixedFocusLimit: Int = 25
    @AppStorage("fixedBreakLimit") private var fixedBreakLimit: Int = 5
    
    
    var body: some View {
        Form {
            Section {
                Picker("Limit Breaktime", selection: $flexBreaktimeLimit) {
                    ForEach([0] + Array(stride(from: 180, through: 600, by: 60)),
                            id: \.self) {
                        LimitOptionsLabel(value: ($0 / 60))
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Factor:")
                    Text("\(flexBreaktimeFactor, format: .number) minutes work for 1 minute pause")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        
                    Slider(value: $flexBreaktimeFactor, in: 1...5, step: 1) {
                        Text("Factor")
                    }
                    
                }
            } header: {
                Text("Fixed Session")
            }
            .padding(.vertical, 10)
            
            Section {
                Picker("Limit Focustime", selection: $fixedFocusLimit) {
                    ForEach(Array(stride(from: 20, through: 60, by: 5)),
                            id: \.self) {
                        LimitOptionsLabel(value: ($0))
                    }
                }
                
                Picker("Limit Breaktime", selection: $fixedBreakLimit) {
                    ForEach(Array(stride(from: 5, through: 20, by: 5)),
                            id: \.self) {
                        LimitOptionsLabel(value: $0)
                    }
                }
            } header: {
                Text("Flexible Session")
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
