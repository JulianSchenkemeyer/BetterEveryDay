//
//  TodayOverview.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 31.08.24.
//

import SwiftUI
import Charts

struct TodayOverview: View {
    var todaysSessions: [SessionSnapshot] = []
    
    var body: some View {
        Card {
            HStack(spacing: 10) {
                VStack {
                    Text("Sessions")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    Text("\(todaysSessions.count)")
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("Total Length")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    HourMinutesDurationTextView(timeInterval: totalLength)
                        .font(.title3)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    var totalLength: TimeInterval {
        todaysSessions.reduce(0.0) { $0 + $1.duration }
    }
}

#Preview {
    TodayOverview(todaysSessions: Mockdata.sessionDataArray.map { $0.snapshot })
}
