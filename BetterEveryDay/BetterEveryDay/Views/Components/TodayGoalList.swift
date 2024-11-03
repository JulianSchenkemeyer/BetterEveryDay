//
//  TodayGoalList.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 08.09.24.
//

import SwiftUI

struct TodayGoalList: View {
    var todaysSessions: [SessionData] = []
    let motivationalQuotes = ["Stay hungry, stay foolish.",
                              "Every day is a new beginning.",
                              "Small steps every day.",
                              "Your potential is endless.",
                              "If you want it, work for it."]
    
    var body: some View {
        Card {
            VStack {
                Text("Last 5 Goals")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                if todaysSessions.isEmpty {
                    ContentUnavailableView(motivationalQuotes.randomElement()!,
                                           systemImage: "list.bullet")
                } else {
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
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 220, alignment: .topLeading)
        }
    }
}

#Preview {
    TodayGoalList(todaysSessions: Mockdata.sessionDataArray)
    TodayGoalList(todaysSessions: [])
}
