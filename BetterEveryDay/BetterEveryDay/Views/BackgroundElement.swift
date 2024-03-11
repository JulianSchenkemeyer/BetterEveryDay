//
//  Background.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 06.02.24.
//

import SwiftUI



struct BackgroundElement: View {
    var size: CGFloat
    var clockwise: Bool = true
    
    var animation: [WanderingShadowAnimation] {
        clockwise ? WanderingShadowAnimation.allCases : WanderingShadowAnimation.allCases.reversed()
    }
    
    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .frame(width: size, height: size)
            .phaseAnimator(animation) { content, phase in
                content
                    .shadow(color: .white.opacity(phase.opacity),
                            radius: phase.radius,
                            x: -phase.offsetX,
                            y: -phase.offsetY)
                    .shadow(color: .black.opacity(phase.opacity),
                            radius: phase.radius,
                            x: phase.offsetX,
                            y: phase.offsetY)
            } animation: { phase in
                phase.animation
            }
    }
}

#Preview {
    BackgroundElement(size: 300, clockwise: false)
}
