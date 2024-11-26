//
//  TimeSpendView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 26.07.23.
//

import SwiftUI
import Charts

struct TimeDistributionChartView: View {
    var totalWorkTime: TimeInterval = 0
    var totalPauseTime: TimeInterval = 0
    
    
    var body: some View {
        Chart {
            Plot {
                BarMark(x: .value("Time", totalWorkTime))
                    .foregroundStyle(by: .value("Category", "Work"))
                
                BarMark(x: .value("Time", totalPauseTime))
                    .foregroundStyle(by: .value("Category", "Pause"))
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
        }
        .chartForegroundStyleScale([
            "Work": .blue,
            "Pause": .blue.opacity(0.5),
        ])
        .chartXScale(domain: 0...1)
        .chartXAxis(.hidden)
        .chartLegend(alignment: .center) {
            HStack(spacing: 30) {
                LegendEntry(title: "Work", value: totalWorkTime, color: .blue)
                
                LegendEntry(title: "Pause", value: totalPauseTime, color: .blue.opacity(0.5))
            }
        }
        .frame(height: 60)
        .padding(.horizontal, 20)
    }
}

struct LegendEntry: View {
    var title: String
    var value: Double
    var color: Color
    
    var body: some View {
        HStack {
            BasicChartSymbolShape.circle
                .foregroundColor(color)
                .frame(width: 8, height: 8)
            
            Text("Work")
                .font(.caption)
                .foregroundStyle(.gray)
            
            Text(value, format: .percent.precision(.fractionLength(0)))
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}


struct TimeSpendView_Previews: PreviewProvider {
    static var previews: some View {
        TimeDistributionChartView(totalWorkTime: 0.6, totalPauseTime: 0.3)
    }
}
