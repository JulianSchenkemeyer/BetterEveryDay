//
//  RequestNotificationView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 06.08.23.
//

import SwiftUI

struct RequestNotificationView: View {
    
    @State private var isPermissionGranted: Bool
    
    init(isPermissionGranted: Bool = false) {
        self.isPermissionGranted = isPermissionGranted
    }
    
    var body: some View {
        HStack {
            Label("Notifications", systemImage: "envelope")
                .font(.title3)
                .fontWeight(.semibold)
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
        )
        .padding(.horizontal, 20)
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
        VStack {
            RequestNotificationView(isPermissionGranted: false)
            RequestNotificationView(isPermissionGranted: true)
        }
    }
}
