//
//  SessionContainer.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.03.25.
//

import SwiftUI

struct SessionContainer<TimerSection: View, InteractionSection: View>: View {
    let goal: String
    @Binding var showSheet: Bool
    
    @ViewBuilder var timerSection: () -> TimerSection
    @ViewBuilder var interactionSection: () -> InteractionSection
    
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("I will...")
                    .foregroundStyle(.secondary)
                Text(goal)
            }
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
            .padding(20)
            
            timerSection()
            
            
        }
        .sheet(isPresented: $showSheet) {
            interactionSection()
                .background(.ultraThinMaterial)
                .presentationDetents([.fraction(0.2), .medium])
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled)
        }
    }
}

#Preview {
    NavigationStack {
        SessionContainer(goal: "Do 10 pushups", showSheet: .constant(true)) {
            Text("Hello World.")
        } interactionSection: {
            Text("Cancel")
        }
    }
}
