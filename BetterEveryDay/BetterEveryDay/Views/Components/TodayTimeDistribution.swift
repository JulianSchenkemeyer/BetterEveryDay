//
//  TodayTimeDistribution.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.09.24.
//

import SwiftUI

struct TodayTimeDistribution: View {
    var todaysSessions: [SessionData] = []
    
    
    var body: some View {
        Card {
            VStack(spacing: 12) {
                Text("Time Distribution")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                TimeDistributionChartView()
            }
        }
    }
    
    func calculateDistribution() -> [TimeDistributionData] {
        todaysSessions.reduce((0.0, 0.0)) {
            $0 + $1.segments.reduce((0.0, 0.0)) {
                
            }
        }
        
        
        return []
    }
}

#Preview {
    TodayTimeDistribution(todaysSessions: Mockdata.sessionDataArray)
}
