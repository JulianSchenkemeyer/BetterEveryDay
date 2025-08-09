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
        .chartOverlay { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame, let segment = selectedSegement {
                    let frame = geometry[plotFrame]
                    
                    TooltionTipView(duration: segment.duration)
                        .position(x: frame.midX,
                                  y: frame.minY - 16)
                }
            }
        }
        .frame(height: 32)
    }
}

private struct TooltionTipView: View {
    var duration: TimeInterval
    
    var body: some View {
        Text("\(Duration.seconds(duration), format: .units(allowed: [.minutes, .seconds], width: .narrow))")
            .padding(.horizontal ,8)
            .padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(lineWidth: 1)
            }
    }
}


#Preview {
    VStack {
        TimelineChartView(data: [], sessionStarted: Date())
        
        TooltionTipView(duration: 156)
    }
}
