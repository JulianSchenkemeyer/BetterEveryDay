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
