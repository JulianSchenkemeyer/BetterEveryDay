//
//  RequestNotificationView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 06.08.23.
//

import SwiftUI

struct RequestNotificationView: View {
    
    @State private var isPermissionGranted: Bool = false
    
    var body: some View {
        HStack {
            Label("Notifications", systemImage: "envelope")
            Spacer()
            if isPermissionGranted {
                BadgeLabelView(text: "Allowed", tint: .green)
            } else {
                Button {
                    Task {
                        await requestPermission()
                    }
                } label: {
                    BadgeLabelView(text: "Allow", tint: .accentColor)
                }

            }
        }
        .task {
            await getPermissionStatus()
        }
    }
    
    private func getPermissionStatus() async {
        isPermissionGranted = await NotificationHelper.checkNotificationPermissionStatus()
    }
    
    private func requestPermission() async {
        do {
            isPermissionGranted = try await NotificationHelper.requestNofificationPermission()
        } catch {
            print("Error requesting notification permission")
        }
    }
}

struct RequestNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        RequestNotificationView()
    }
}
