//
//  FixedSessionScreen.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 28.01.25.
//

import SwiftUI



struct FixedSessionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(NotificationManager.self) private var notificationManager
    @Environment(\.persistenceManager) var persistenceManager
    
    @State private var timer: Timer?
    
    var goal: String
    var viewModel: ClassicSession
    
    
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
                        switch newValue {
                        case .Focus:
                            removeScheduledNotifications()
                        case .Pause:
                            schedulePauseEndedNotification()
                        }
                        resetTimer()
                        scheduleSessionChange()
                    }
                    .onAppear {
                        scheduleSessionChange()
                        guard segment.category == .Pause else { return }
                    }
                }
                
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
                await persistenceManager?.updateSession(with: breaktime, segment: segment)
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
                await persistenceManager?.updateSession(with: breaktime, segment: segment)
            }
        }
        dismiss()
    }
    
    private func scheduleSessionChange() {
        guard let segment = viewModel.getCurrent() else {
            return
        }

        self.timer = Timer.scheduledTimer(withTimeInterval: segment.duration, repeats: false, block: { _ in
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
    private func schedulePauseEndedNotification() {
        guard let segment = viewModel.getCurrent() else {
            return
        }
        let triggerDate = segment.startedAt + viewModel.availableBreak
        let notification = PauseEndedNotification(triggerAt: triggerDate)
        
        notificationManager.schedule(notification: notification)
    }
    
    /// Remove all currently scheduled local notifications
    private func removeScheduledNotifications() {
        notificationManager.removeScheduledNotifications()
    }
}

#Preview {
    @Previewable @State var session = ClassicSession(segments: [], focustimeLimit: 1, breaktimeLimit: 1)
    
    FixedSessionScreen(goal: "work on session screen work on session screen", viewModel: session)
        .environment(NotificationManager(notificationService: NotificationServiceMock()))
        .environment(\.persistenceManager, PersistenceManagerMock())
        .onAppear {
            session.next()
            print(session.segments.count)
        }
}
