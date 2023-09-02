//
//  ContentView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.05.23.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        
        NavigationStack {
            ThirdTimeView(notificationService: NotificationService(notificationCenter: .current()))
                .navigationTitle("Session")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
