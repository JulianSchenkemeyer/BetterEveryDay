//
//  HourMinutesDurationTextView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 26.07.23.
//

import SwiftUI

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
struct HourMinutesDurationTextView_Previews: PreviewProvider {
    static var previews: some View {
        HourMinutesDurationTextView(timeInterval: 500.543)
    }
}
