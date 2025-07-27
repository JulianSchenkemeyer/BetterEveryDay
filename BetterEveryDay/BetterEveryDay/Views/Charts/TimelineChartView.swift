//
//  SessionProgressChartView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 20.07.25.
//

import SwiftUI
import Charts


struct TimelineChartView: View {
    var data: [SessionSegment]
    var isExpanded = false
    
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            Chart(data) { segment in
                let duration = if segment.isRunning { context.date.timeIntervalSince(segment.startedAt)
                } else {
                    segment.duration
                }
                Plot {
                    BarMark(x: .value("Time", duration))
                        .foregroundStyle(by: .value("Category", segment.category.rawValue))
                }
            }
            .animation(.easeIn(duration: 0.5), value: context.date)

        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
        }
        .chartForegroundStyleScale([
            "Focus": .blue,
            "Pause": .blue.opacity(0.5),
        ])
        .chartXAxis(.hidden)
        .chartLegend(.hidden)
//        .chartLegend(alignment: .center) {
//            HStack(spacing: 30) {
//                LegendEntry(title: "Work", value: totalWorkTime, color: .blue)
//                
//                LegendEntry(title: "Pause", value: totalPauseTime, color: .blue.opacity(0.5))
//            }
//            Text("Segments: \(data.last?.duration.description ?? "_")")
//        }
        .frame(height: isExpanded ? 48 : 24)
    }
}


#Preview {
    @Previewable @State var expand = true
    
    TimelineChartView(data: [], isExpanded: expand)
    
    Button("Toggle expanded") {
        expand.toggle()
    }
}
