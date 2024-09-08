//
//  TodayGoalList.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 08.09.24.
//

import SwiftUI

struct TodayGoalList: View {
    var todaysSessions: [SessionData] = []
    
    var body: some View {
        Card {
            VStack {
                Text("Last 5 Goals")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                ForEach(todaysSessions.prefix(5)) { session in
                    HStack(alignment: .bottom) {
                        Text(session.goal)
                            .font(.body)
                        Spacer()
                        HourMinutesDurationTextView(timeInterval: session.duration)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.bottom, 1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    TodayGoalList(todaysSessions: Mockdata.sessionDataArray)
}
