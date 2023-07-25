//
//  ReflectSessionView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.06.23.
//

import SwiftUI
import Charts

struct HourMinutesDurationTextView: View {
    
    let formatter: DateComponentsFormatter
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
        
        self.formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .abbreviated
    }
    
    var body: some View {
        Text(formatter.string(from: timeInterval) ?? "")
    }
}

struct TimeSpentData: Identifiable {
    let id = UUID()
    
    let part: Double
    let category: String
}

struct TimeSpentView: View {
    var data: [TimeSpentData] = []
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

struct ReflectSessionView: View {
    @Binding var state: ThirdTimeState
    
    let totalFocusTime: TimeInterval
    let totalBreakTime: TimeInterval
    let restBreakTime: TimeInterval
    
    
    var body: some View {
        VStack(spacing: 40) {
            Text("REFLECT")
                .modifier(PhaseLabelModifier())
            
            TimeSpentView(totalFocusTime: totalFocusTime,
                          totalBreakTime: totalBreakTime,
                          restBreakTime: restBreakTime)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Total Focus Time:")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                    HourMinutesDurationTextView(timeInterval: totalFocusTime)
                }
                
                HStack {
                    Text("Total Break Time:")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                    HourMinutesDurationTextView(timeInterval: totalBreakTime)
                }
                
                HStack {
                    Text("Rest Break Time:")
                        .font(.body)
                        .fontWeight(.semibold)
                    Spacer()
                    HourMinutesDurationTextView(timeInterval: restBreakTime)
                }
                
            }.padding(.horizontal, 80)
            
            
            Button {
                state = .Prepare
            } label: {
                Label("Restart", systemImage: "play")
            }
            .primaryButtonStyle()
        }
    }
}

struct ReflectSessionView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectSessionView(state: .constant(.Reflect),
                           totalFocusTime: 21.46406602859497,
                           totalBreakTime: 5.301582098007202,
                           restBreakTime: 1.37322195370992)
    }
}
