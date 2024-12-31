//
//  TodayTimeDistribution.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.09.24.
//

import SwiftUI
import BetterEveryDayPersistence

struct TodayTimeDistribution: View {
    var todaysSessions: [SessionData] = []
    
    var chartData: (work: Double, pause: Double) {
        var totalDuration = 0.0
        var totalWorkTime = 0.0
        var totalPauseTime = 0.0
        
        for session in todaysSessions {
            totalDuration += session.duration
            totalWorkTime += session.timeSpendWork
            totalPauseTime += session.timeSpendPause
        }
        
        let workPercentage = totalWorkTime / totalDuration
        let pausePercentage = totalPauseTime / totalDuration
        
        return (work: workPercentage.isNaN ? 0.0 : workPercentage,
                pause: pausePercentage.isNaN ? 0.0 : pausePercentage)
    }
    
    var body: some View {
        Card {
            VStack(spacing: 12) {
                Text("Time Distribution")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                TimeDistributionChartView(totalWorkTime: chartData.work,
                                          totalPauseTime: chartData.pause)
            }
        }
    }
}

#Preview {
    TodayTimeDistribution(todaysSessions: Mockdata.sessionDataArray)
}
