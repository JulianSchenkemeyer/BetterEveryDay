//
//  TodayGoalList.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 08.09.24.
//

import SwiftUI

struct TodayGoalList: View {
    var todaysSessions: [SessionSnapshot] = []
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
                                           systemImage: Icons.todaysSessionsEmpty)
                } else {
                    ForEach(todaysSessions.prefix(5)) { session in
                        HStack(alignment: .bottom) {
                            if session.type == SessionType.flexible.rawValue {
                                Image(systemName: Icons.flexibleSession)
                            } else {
                                Image(systemName: Icons.fixedSession)
                            }
                            
                            Text(session.goal)
                                .lineLimit(1)
                                .font(.body)
                            Spacer(minLength: 40)
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
    TodayGoalList(todaysSessions: Mockdata.sessionDataArray.map { $0.snapshot })
    TodayGoalList(todaysSessions: [])
}
