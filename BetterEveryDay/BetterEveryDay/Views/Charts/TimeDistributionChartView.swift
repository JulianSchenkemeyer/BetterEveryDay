//
//  TimeSpendView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 26.07.23.
//

import SwiftUI
import Charts

struct TimeDistributionChartView: View {
    var data: [TimeDistributionData] = []
    var total: TimeInterval = 0
    
//    init(totalFocusTime: TimeInterval, totalBreakTime: TimeInterval) {
//        total = totalFocusTime + totalBreakTime
//        
//        data.append(.init(part: (totalFocusTime / total), category: "Focus"))
//        data.append(.init(part: (totalBreakTime / total), category: "Break taken"))
//        
//        data.forEach { item in
//            print(item.part, item.category, total)
//        }
//        print(data.count)
//    }
    
    var body: some View {
        Chart(data) { item in
            Plot {
                BarMark(x: .value("Time", item.part))
                    .foregroundStyle(by: .value("Category", item.category))
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
        }
        .chartForegroundStyleScale([
            "Focus": .blue,
            "Break taken": .blue.opacity(0.5),
        ])
        .chartXScale(domain: 0...1)
        .chartXAxis(.hidden)
        .chartLegend(alignment: .center)
        .frame(height: 60)
        .padding(.horizontal, 20)
    }
}

struct TimeSpendView_Previews: PreviewProvider {
    static var previews: some View {
        TimeDistributionChartView()
    }
}
