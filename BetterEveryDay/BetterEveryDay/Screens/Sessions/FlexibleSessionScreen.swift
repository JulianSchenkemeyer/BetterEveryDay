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
    @State private var showSessionController = true
    
    var goal: String
    var viewModel: SessionProtocol
    
    
    var body: some View {
        if let segment = viewModel.getCurrent() {
            
            SessionContainer(goal: goal, showSheet: $showSessionController) {
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
                }
                .onAppear {
                    guard segment.category == .Pause else { return }
                    goneOvertime = (segment.startedAt + viewModel.availableBreak) < .now
                }
                
                Spacer()
                
                
                
            } interactionSection: { selectedDetent in
                VStack(spacing: 24) {
                    TimelineChartView(data: viewModel.segments)
                    
                    HStack(spacing: 10) {
                        Button {
                            createNextSegment()
                        } label: {
                            Label(segment.category == .Focus ? "Pause" : "Focus", systemImage: segment.category == .Focus ? "pause.fill" : "play.fill")
                                .frame(maxWidth: .infinity)
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.9))
                                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                                .background(Color.black.gradient)
                                .clipShape(Capsule())
                        }
                        
                        Button {
                            showSessionController = false
                            finishSession()
                        } label: {
                            Label("Finish", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.9))
                                .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                                .background(Color.red.gradient)
                                .clipShape(Capsule())
                        }
                    }
                    
                    if selectedDetent == .medium {
                        SessionOverviewChartView(data: viewModel.segments)
                        
                        VStack {
                            Text("Available Breaktimes: \(Duration.seconds(viewModel.availableBreak), format: .units(allowed: [.minutes, .seconds], width: .narrow))")
                        }
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxHeight: .infinity, alignment: .top)
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
                Task { @MainActor in
                    goneOvertime = true
                }
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
    @Previewable @State var session = FlexibleSession(segments: [.init(category: .Focus, startedAt: .now)])
    
    NavigationStack {
        FlexibleSessionScreen(goal: "work on session screen work on session screen", viewModel: session)
    }
    .environment(NotificationManager(notificationService: NotificationServiceMock()))
    .environment(\.persistenceManager, PersistenceManagerMock())
}
