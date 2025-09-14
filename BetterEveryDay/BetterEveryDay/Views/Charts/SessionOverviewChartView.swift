//
//  SessionOverviewChartView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 09.08.25.
//
import SwiftUI
import Charts

//TODO: * bordered segments; * RuleMark indicating ratio; * Tooltip; * Sum als legende


struct SessionOverviewChartView: View {
    var data: [SessionSegment]
        
    var body: some View {
        Chart(data) { segment in
            BarMark(
                x:.value(
                    "Duration",
                    segment.duration
                ),
                y:.value("Category", segment.category.rawValue),
            )
            .cornerRadius(8, style: .continuous)
            .foregroundStyle(by: .value("Category", segment.category.rawValue))

            
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend {
            
        }
//        .chartScrollableAxes(.horizontal)
        
    }
}

#Preview {
    SessionOverviewChartView(data: Mockdata.sessionSegments + Mockdata.sessionSegments)
        .padding()
        .frame(height: 180)
}
