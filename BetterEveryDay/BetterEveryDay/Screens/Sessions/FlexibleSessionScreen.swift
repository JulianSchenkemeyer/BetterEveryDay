//
//  SessionScreen.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 19.03.24.
//

import SwiftUI



struct FlexibleSessionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(NotificationManager.self) private var notificationManager
    @Environment(\.persistenceManager) var persistenceManager
    
    @State private var goneOvertime = false
    @State private var timer: Timer?
    
    var goal: String
    var viewModel: SessionProtocol
    
    
    var body: some View {
        SessionContainer(goal: goal, onFinishSession: finishSession) {
            if let segment = viewModel.getCurrent() {
                VStack {
                    if segment.category == .Focus {
                        TimerLabelView(date: segment.startedAt)
                    } else {
                        TimerLabelView(date: segment.startedAt + viewModel.availableBreak)
                            .foregroundStyle(goneOvertime ? .red : .primary)
                            .task {
                                await goOvertimeTimer()
                            }
                    }
                    Text(segment.category.rawValue)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .tracking(1.1)
                        .fontWeight(.semibold)
                }
                .onChange(of: segment.category) { _, newValue in
                    removeScheduledNotifications()
                    
                    switch newValue {
                    case .Focus:
                        resetTimer()
                    case .Pause:
                        schedulePauseEndedNotification()
                    }
                    scheduleFollowUpNotification()
                }
                .onAppear {
                    guard segment.category == .Pause else { return }
                    goneOvertime = (segment.startedAt + viewModel.availableBreak) < .now
                }
                
                Spacer()
                
                Button {
                    createNextSegment()
                } label: {
                    Text(segment.category == .Focus ? "Pause" : "Focus")
                        .font(.body)
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                        .background(.primary)
                        
                }
                .clipShape(.capsule)
                .defaultShadow()
                .padding([.bottom, .horizontal], 40)
            }
            
        }
    }
    
    
    /// Create a new segment for the current session
    private func createNextSegment() {
        guard let segment = viewModel.getCurrent() else {
            return
        }
        
        viewModel.next() { breaktime, segment in
            Task {
                try await persistenceManager?.updateSession(with: breaktime, segment: segment)
            }
        }
        removeScheduledNotifications()
        if segment.category == .Focus {
            goneOvertime = false
        }
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
    
    /// Reset the go overtime timer
    private func resetTimer() {
        if timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    /// Switch to overtime mode, when the available breaktime is over
    private func goOvertimeTimer() async {
        if viewModel.availableBreak > 0 {
            self.timer = Timer.scheduledTimer(withTimeInterval: viewModel.availableBreak, repeats: false, block: { _ in
                goneOvertime = true
            })
        } else {
            goneOvertime = true
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
    
    /// Schedule a follow up notification for the case the user has not opened the app for some time and there is a session running
    private func scheduleFollowUpNotification() {
        let followUpDate = Calendar.current.date(byAdding: .minute, value: 60, to: .now)!
        let notification = FollowUpNotification(triggerAt: followUpDate)
        notificationManager.schedule(notification: notification)
    }
    
    /// Remove all currently scheduled local notifications
    private func removeScheduledNotifications() {
        notificationManager.removeScheduledNotifications()
    }
}

#Preview {
    @Previewable @State var session = FlexibleSession(segments: [.init(category: .Focus, startedAt: .now)])
    
    NavigationStack {
        FlexibleSessionScreen(goal: "work on session screen work on session screen", viewModel: session)
    }
    .environment(NotificationManager(notificationService: NotificationServiceMock()))
    .environment(\.persistenceManager, PersistenceManagerMock())
}
