//
//  TimerView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 25.06.23.
//

import SwiftUI

struct TimerLabelView: View {
    var date: Date
    
    var body: some View {
        Text(date, style: .timer)
            .font(.system(size: 80))
            .fontWeight(.bold)
    }
}

struct TimerLabelView_Previews: PreviewProvider {
    static var previews: some View {
        TimerLabelView(date: Date.now)
    }
}
