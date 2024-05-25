//
//  SessionScreen.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.03.24.
//

import SwiftUI

struct SessionScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Goal")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                    .padding(20)
                
                VStack {
                    TimerLabelView(date: .now)
                    Text("Work")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .tracking(1.1)
                        .fontWeight(.semibold)
                }
                
                
                Button {
                    
                } label: {
                    Text("Pause")
                }
                .primaryButtonStyle()
                .padding(.top, 80)

                
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Finish")
                    }

                }
            }
            .navigationTitle("Session")
        }
    }
}

#Preview {
    Text("test")
        .sheet(isPresented: .constant(true)) {
            SessionScreen()
        }
}
