//
//  MKPositionView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 28/01/2024.
//

import SwiftUI

struct MKPositionView: View {
    
    let position: Int
    let onClick: () -> Void
    let visible: Bool
    
    var alpha: CGFloat {
        return if (visible) {
            0.5
        } else {
            0
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            if (visible) {
                MKTextView(label: String(position), font: "MarioKartPositionFontRegular", fontSize: 42, fontColor: Color(UIColor(intColor: positionColor(position: position))))
            }
            Spacer()

        }
        .frame(maxWidth: .infinity)
        .background(
            Color(UIColor(hexColor: .white).withAlphaComponent(alpha))
        )
        .onTapGesture {
            if (visible) {
                onClick()
            }
        }
    }
}

