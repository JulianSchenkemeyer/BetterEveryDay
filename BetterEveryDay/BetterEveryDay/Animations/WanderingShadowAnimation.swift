//
//  WanderingShadowAnimation.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 11.03.24.
//

import Foundation


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
