//
//  SessionContainer.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.03.25.
//

import SwiftUI

struct SessionContainer<TimerSection: View, InteractionSection: View>: View {
    let goal: String
    @State private var selectedDetent: PresentationDetent = .fraction(0.2)
    
    @Binding var showSheet: Bool
    
    @ViewBuilder var timerSection: () -> TimerSection
    @ViewBuilder var interactionSection: (_ selectedDetent: PresentationDetent) -> InteractionSection
    
    
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
            ScrollView{
                interactionSection(selectedDetent)
                    .padding(.top, 40)
            }
            .scrollBounceBehavior(.basedOnSize)
            .background(.ultraThinMaterial)
            .presentationDetents([.fraction(0.2), .medium], selection: $selectedDetent)
            .interactiveDismissDisabled()
            .presentationBackgroundInteraction(.enabled)
        }
    }
}

#Preview {
    NavigationStack {
        SessionContainer(goal: "Do 10 pushups", showSheet: .constant(true)) {
            Text("Hello World.")
        } interactionSection: { _ in 
            Text("Cancel")
        }
    }
}
