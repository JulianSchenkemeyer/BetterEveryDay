//
//  TodayOverview.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 31.08.24.
//

import SwiftUI
import Charts

struct TodayOverview: View {
    var body: some View {
        VStack {
            HStack {
                Text("Daily Summary")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(.now, format: .dateTime.day().month().year())
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .font(.subheadline)

            Divider()
            
            HStack(spacing: 10) {
                VStack {
                    Text("Sessions")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    Text("4")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack {
                    Text("Total Length")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    Text("6:18")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
            }
            Divider()
            
            Spacer(minLength: 50)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 250)
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 1, y: 1)
                .shadow(color: .white.opacity(0.3), radius: 2, x: -1, y: -1)
        }
        
    }
        
}

#Preview {
    TodayOverview()
        .padding()
}
