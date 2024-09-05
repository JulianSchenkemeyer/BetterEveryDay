//
//  TodayOverview.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 31.08.24.
//

import SwiftUI
import Charts

struct TodayOverview: View {
    
    var todaysSessions: [SessionData] = []
    
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
                    
                    Text("\(todaysSessions.count)")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack {
                    Text("Total Length")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    HourMinutesDurationTextView(timeInterval: totalLength)
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
    
    var totalLength: TimeInterval {
        todaysSessions.reduce(0.0) { partialResult, sessionData in
            let duration = sessionData.segments.reduce(0.0, { partialResult, sessionSegmentData in
                partialResult + sessionSegmentData.duration
            })
            print("\(partialResult) + \(duration)")
            
            return partialResult + duration
            
        }
    }
        
}

#Preview {
    TodayOverview()
        .padding()
}
