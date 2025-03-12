//
//  FixedSessionScreen.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.01.25.
//

import SwiftUI



struct FixedSessionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @Environment(NotificationManager.self) private var notificationManager
    @Environment(\.persistenceManager) var persistenceManager
    
    @State private var timer: Timer?
    
    var goal: String
    var viewModel: SessionProtocol
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    Text("I will...")
                        .foregroundStyle(.secondary)
                    Text(goal)
                }
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                .padding(20)
                
                if let segment = viewModel.getCurrent(), let finishedAt = segment.finishedAt {
                    VStack {
                        if segment.category == .Focus {
                            TimerLabelView(date: finishedAt)
                        } else {
                            TimerLabelView(date: finishedAt)
                        }
                        Text(segment.category.rawValue)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .tracking(1.1)
                            .fontWeight(.semibold)
                    }
                    .onChange(of: segment.category) { _, newValue in
                        removeScheduledNotifications()
                        scheduleNotifications(startingWith: newValue)
                        
                        resetTimer()
                        scheduleSessionChange()
                    }
                    .onChange(of: scenePhase) { _, newValue in
                    }
                    .onAppear {
                        scheduleSessionChange()
                        scheduleNotifications(startingWith: segment.category)
                    }
                }
                Spacer()
                
                Card {
                    VStack {
                        Text(ceil(Double(viewModel.segments.count / 2)).formatted())
                            .font(.largeTitle)
                        
                        Text("Focus segments completed")
                    }
                        .font(.body)
                        .padding()
                }.padding(.horizontal, 40)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        finishSession()
                    } label: {
                        Text("Finish")
                    }
                }
            }
        }
    }
    
    /// Create a new segment for the current session
    private func createNextSegment() {
        viewModel.next() { breaktime, segment in
            Task {
                try await persistenceManager?.updateSession(with: breaktime, segment: segment)
            }
        }
        removeScheduledNotifications()
    }
    
    /// Finish the current session
    private func finishSession() {
        resetTimer()
        
        removeScheduledNotifications()
        viewModel.endSession() { breaktime, segment in
            Task {
                try await persistenceManager?.updateSession(with: breaktime, segment: segment)
            }
        }
        dismiss()
    }
    
    /// Schedule the automatic change of session phases (focus - pause). It creates a new Timer object
    /// scheduled to execute when the the segment ends and creates a new segment.
    private func scheduleSessionChange() {
        guard let segment = viewModel.getCurrent() else {
            return
        }

        let timeleft = segment.finishedAt!.timeIntervalSince1970 - Date.now.timeIntervalSince1970
        self.timer = Timer.scheduledTimer(withTimeInterval: timeleft, repeats: false, block: { _ in
            createNextSegment()
        })
    }
    
    /// Reset the go overtime timer
    private func resetTimer() {
        if timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    /// Schedule a local notification for when the pause is ended
    private func scheduleNotifications(startingWith category: SegmentCategory) {
        guard let viewModel = viewModel as? FixedSession,
              let segment = viewModel.getCurrent(),
              let finishedAt = segment.finishedAt else {
            return
        }
                
        let inOneHour = Calendar.current.date(byAdding: .hour, value: 1, to: finishedAt)!
        var triggerAt = finishedAt
        var categoryOfNotification: SegmentCategory = category
        
        while triggerAt < inOneHour {
            var notification: any BEDNotification
            var advanceByValue: Int
            if categoryOfNotification == .Focus {
                notification = FocusEndedNotification(triggerAt: triggerAt)
                advanceByValue = viewModel.focustimeLimit
                categoryOfNotification = .Pause
            } else {
                notification = PauseEndedNotification(triggerAt: triggerAt)
                advanceByValue = viewModel.breaktimeLimit
                categoryOfNotification = .Focus
            }
            notificationManager.schedule(notification: notification)
            triggerAt = Calendar.current.date(byAdding: .minute, value: advanceByValue, to: triggerAt)!
        }
        
        scheduleFollowUpNotification(for: triggerAt)
    }
    
    /// Schedule a follow up notification for the case the user has not opened the app for some time and there is a session running
    private func scheduleFollowUpNotification(for triggerAt: Date) {
        let followUpDate = Calendar.current.date(byAdding: .minute, value: 10, to: triggerAt)!
        let notification = FollowUpNotification(triggerAt: followUpDate)
        notificationManager.schedule(notification: notification)
    }
    
    /// Remove all currently scheduled local notifications
    private func removeScheduledNotifications() {
        notificationManager.removeScheduledNotifications()
    }
}

#Preview {
    @Previewable @State var session = FixedSession(segments: [], focustimeLimit: 1, breaktimeLimit: 1)
    
    FixedSessionScreen(goal: "work on session screen work on session screen", viewModel: session)
        .environment(NotificationManager(notificationService: NotificationServiceMock()))
        .environment(\.persistenceManager, PersistenceManagerMock())
        .onAppear {
            session.next()
            print(session.segments.count)
        }
}
