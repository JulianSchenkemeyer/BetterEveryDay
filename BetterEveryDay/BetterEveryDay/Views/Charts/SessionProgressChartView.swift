//
//  SessionProgressChartView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 20.07.25.
//

import SwiftUI
import Charts

struct SessionProgress {
    var sessionLength: TimeInterval {
        segments.reduce(0) { partialResult, segment in
            partialResult + segment.length
        }
    }
    let segments: [SessionProgressSegment]
    
    init(segments: [SessionProgressSegment]) {
        self.segments = segments
    }
    
    init(segments: [SessionSegment]) {
        self.segments = segments.map {
            return SessionProgressSegment(
                category: $0.category,
//                part: $0.duration / sessionLength,
                length: $0.duration
        )}
    }
}

struct SessionProgressSegment: Hashable {
    let category: SegmentCategory
//    let part: Double
    let length: TimeInterval
}

struct SessionProgressChartView: View {

    var data: SessionProgress
    
    
    var body: some View {
        Chart(data.segments, id: \.self) { segment in
            Plot {
                BarMark(x: .value("Time", segment.length))
                    .foregroundStyle(by: .value("Category", segment.category.rawValue))
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
//        .chartXScale(domain: 0...1)
        .chartXAxis(.hidden)
        .chartLegend(.hidden)
//        .chartLegend(alignment: .center) {
//            HStack(spacing: 30) {
//                LegendEntry(title: "Work", value: totalWorkTime, color: .blue)
//                
//                LegendEntry(title: "Pause", value: totalPauseTime, color: .blue.opacity(0.5))
//            }
//        }
        .frame(height: 24)
    }
}

//struct LegendEntry: View {
//    var title: String
//    var value: Double
//    var color: Color
//    
//    var body: some View {
//        HStack {
//            BasicChartSymbolShape.circle
//                .foregroundColor(color)
//                .frame(width: 8, height: 8)
//            
//            Text(title)
//                .font(.caption)
//                .foregroundStyle(.gray)
//            
//            Text(value, format: .percent.precision(.fractionLength(0)))
//                .font(.caption)
//                .foregroundStyle(.gray)
//        }
//    }
//}


struct SessionProgressChartView_Previews: PreviewProvider {
    static var previews: some View {
        SessionProgressChartView(
            data: .init(
                segments: [
                    .init(
                        category: .Focus,
                        
                        length: 50.0
                    ),
                    .init(
                        category: .Pause,
                        
                        length: 20.0
                    ),
                    .init(
                        category: .Focus,
                        
                        length: 30.0
                    )
                ]
            )
        )
    }
}
