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
    
    var totals: (focus: TimeInterval, pause: TimeInterval) {
        data.reduce(into: (focus: .zero, pause: .zero)) { result, segment in
            switch segment.category {
            case .Focus:
                result.focus += segment.duration
            case .Pause:
                result.pause += segment.duration
            }
        }
    }
    
    var ratio: TimeInterval {
        totals.focus / 3
    }
        
    var body: some View {
        Chart {
            ForEach(data) { segment in
                BarMark(
                    x: .value(
                        "Duration",
                        segment.duration
                    ),
                    y: .value("Category", segment.category.rawValue)
                )
                .cornerRadius(8, style: .continuous)
                .foregroundStyle(by: .value("Category", segment.category.rawValue))
            }

            RuleMark(x: .value("Marker", ratio))
                .foregroundStyle(.secondary)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [4]))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend {
            VStack(alignment: .leading) {
                Text("Focus: \(Duration.seconds(totals.focus), format: .units(allowed: [.hours, .minutes, .seconds], width: .narrow))")
                Text("Pause: \(Duration.seconds(totals.pause), format: .units(allowed: [.hours, .minutes, .seconds], width: .narrow))")
            }
            .foregroundStyle(Color.secondary)
        }
    }
}

#Preview {
    SessionOverviewChartView(
        data: Mockdata.sessionSegments,
    )
        .padding()
        .frame(height: 180)
}

