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
            "Work": .blue,
            "Pause": .blue.opacity(0.5),
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
        TimeDistributionChartView(data: [.init(part: 0.2, category: "Work"), .init(part: 0.3, category: "Pause")])
    }
}
