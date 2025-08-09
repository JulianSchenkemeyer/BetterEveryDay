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
    var sessionStarted: Date = .now

    @State private var selected: TimeInterval? = nil

    var selectedSegement: SessionSegment? {
        guard let selected else { return nil }
        guard let startedAt = data.first?.startedAt else { return nil }
        let time = startedAt.addingTimeInterval(selected)
        
        return data.first {
            $0.startedAt <= time && time <= $0.finishedAt ?? .now
        }
    }
    
    
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
        .chartXSelection(value: $selected)
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
        .frame(height: 36)
        
        if let selected {
            Text("\(selected)")
            Text("\(selectedSegement?.duration)")
        }
    }
}


#Preview {
    TimelineChartView(data: [], sessionStarted: Date())
}
