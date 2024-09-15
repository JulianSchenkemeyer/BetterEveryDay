//
//  TodayTimeDistribution.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.09.24.
//

import SwiftUI

struct TodayTimeDistribution: View {
    var todaysSessions: [SessionData] = []
    
    var chartData: [TimeDistributionData] {
        var totalDuration = 0.0
        var totalWorkTime = 0.0
        var totalPauseTime = 0.0
        
        for session in todaysSessions {
            totalDuration += session.duration
            totalWorkTime += session.timeSpendWork
            totalPauseTime += session.timeSpendPause
        }
        
        print("\(totalWorkTime), \(totalPauseTime)")
        return [.init(part: totalWorkTime / totalDuration, category: "Work"),
                .init(part: totalPauseTime / totalDuration, category: "Pause")]
    }
    
    var body: some View {
        Card {
            VStack(spacing: 12) {
                Text("Time Distribution")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                TimeDistributionChartView(data: chartData)
            }
        }
    }
}

#Preview {
    TodayTimeDistribution(todaysSessions: Mockdata.sessionDataArray)
}
