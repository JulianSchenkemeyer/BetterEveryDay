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
                        switch newValue {
                        case .Focus:
                            resetTimer()
                            removeScheduledNotifications()
                        case .Pause:
                            schedulePauseEndedNotification()
                        }
                    }
                    .onAppear {
                        guard segment.category == .Pause else { return }
                        goneOvertime = (segment.startedAt + viewModel.availableBreak) < .now
                    }
                    
                    Button {
                        createNextSegment()
                    } label: {
                        Text(segment.category == .Focus ? "Pause" : "Focus")
                    }
                    .primaryButtonStyle()
                    .padding(.top, 80)
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
        guard let segment = viewModel.getCurrent() else {
            return
        }
        
        viewModel.next() { breaktime, segment in
            Task {
                await persistenceManager?.updateSession(with: breaktime, segment: segment)
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
                await persistenceManager?.updateSession(with: breaktime, segment: segment)
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
    
    /// Remove all currently scheduled local notifications
    private func removeScheduledNotifications() {
        notificationManager.removeScheduledNotifications()
    }
}

#Preview {
    FlexibleSessionScreen(goal: "work on session screen work on session screen", viewModel: ThirdTimeSession(segments: [.init(category: .Focus, startedAt: .now)]))
        .environment(NotificationManager(notificationService: NotificationServiceMock()))
        .environment(\.persistenceManager, PersistenceManagerMock())
}
