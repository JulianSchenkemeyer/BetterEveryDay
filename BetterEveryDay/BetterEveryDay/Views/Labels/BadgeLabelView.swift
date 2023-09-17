//
//  BadgeLabelView.swift
//  BetterEveryDay
//
//  Created by Julian Schenkemeyer on 06.08.23.
//

import SwiftUI

struct BadgeLabelView: View {
    var text: String
    var tint: Color
    
    var body: some View {
        Text(text)
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundColor(tint)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(tint.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .shadow(radius: 0.2, x: 0.3, y: 0.3)
                    )
            )
    }
}

struct BadgeLabelView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeLabelView(text: "Allowed", tint: .green)
    }
}
