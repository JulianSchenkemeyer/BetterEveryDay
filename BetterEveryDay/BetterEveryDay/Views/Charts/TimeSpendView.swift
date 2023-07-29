//
//  TimeSpendView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 26.07.23.
//

import SwiftUI
import Charts

struct TimeSpendView: View {
    var data: [TimeSpendData] = []
    var total: TimeInterval
    
    init(totalFocusTime: TimeInterval, totalBreakTime: TimeInterval, restBreakTime: TimeInterval) {
        total = totalFocusTime + totalBreakTime + restBreakTime
        
        data.append(.init(part: (totalFocusTime / total), category: "Focus"))
        data.append(.init(part: (totalBreakTime / total), category: "Break taken"))
        data.append(.init(part: (restBreakTime / total), category: "Break not taken"))
        
        data.forEach { item in
            print(item.part, item.category, total)
        }
        print(data.count)
    }
    
    var body: some View {
        Chart(data) { item in
            Plot {
                BarMark(x: .value("Time", item.part))
                    .foregroundStyle(by: .value("Phase", item.category))
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
        
        }
        .chartForegroundStyleScale([
            "Focus": .blue,
            "Break taken": .orange,
            "Break not taken": .gray.opacity(0.5)
        ])
        .chartXScale(domain: 0...1)
        .chartXAxis(.hidden)
        .chartLegend(alignment: .center)
        .frame(height: 80)
        .padding(.horizontal, 20)
    }
}

struct TimeSpendView_Previews: PreviewProvider {
    static var previews: some View {
        TimeSpendView(totalFocusTime: 21.46406602859497,
                      totalBreakTime: 5.301582098007202,
                      restBreakTime: 1.37322195370992)
    }
}
