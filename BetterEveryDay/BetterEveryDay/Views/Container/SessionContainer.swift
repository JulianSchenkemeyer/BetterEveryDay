//
//  SessionContainer.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 18.03.25.
//

import SwiftUI

struct SessionContainer<Content: View>: View {
    let goal: String
    let onFinishSession: () -> Void
    
    @ViewBuilder var content: () -> Content
    
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
            
            content()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onFinishSession()
                } label: {
                    Text("Finish")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SessionContainer(goal: "Do 10 pushups", onFinishSession: { print("Finished!") } ) {
            Text("Hello World.")
        }
    }
}
