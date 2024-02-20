//
//  Background.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 06.02.24.
//

import SwiftUI

struct BackgroundElement: View {
    enum WanderingShadowAnimation: Int, CaseIterable {
        case BottomRight, BottomLeft, TopLeft, TopRight
        
        var offsetX: CGFloat {
            switch self {
            case .BottomLeft, .TopLeft:
                -1
            case .BottomRight, .TopRight:
                1
            }
        }
        
        var offsetY: CGFloat {
            switch self {
            case .BottomLeft, .BottomRight:
                1
            case .TopLeft, .TopRight:
                -1
            }
        }
        
        var  radius: CGFloat {
            switch self {
            case .BottomLeft, .TopRight:
                1
            case .BottomRight, .TopLeft:
                1
            }
        }
        
        var opacity: Double {
            switch self {
            case .BottomLeft, .TopRight:
                0.4
            case .BottomRight, .TopLeft:
                0.4
            }
        }
        
        var animation: Animation {
            .linear(duration: 0.9)
        }
    }
    
    var size: CGFloat
    
    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .frame(width: size, height: size)
            .phaseAnimator(WanderingShadowAnimation.allCases) { content, phase in
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
    BackgroundElement(size: 300)
}
