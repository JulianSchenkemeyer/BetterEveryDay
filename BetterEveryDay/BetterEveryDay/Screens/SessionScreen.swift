//
//  SessionScreen.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.03.24.
//

import SwiftUI

struct SessionScreen: View {
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
                    Text("focus")
                        .font(.body)
                        .bold()
                }
                
                
                Spacer()
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
