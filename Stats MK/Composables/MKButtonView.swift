//
//  MKButtonView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import SwiftUI

struct MKButtonView: View {
    var onClick: () -> Void
    var label = ""
    var enabled = true
    
    init(label: String, enabled: Bool = true, onClick: @escaping () -> Void) {
        self.label = label
        self.onClick = onClick
        self.enabled = enabled
    }
    
    var body: some View {
        
        var textColor: Color {
            return if (enabled) {
                Color(UIColor(hexColor: .white))
            } else {
                Color(UIColor(hexColor: .white).withAlphaComponent(0.5))

            }
        } 
        var bgColor: Color {
            return if (enabled) {
                Color(UIColor(hexColor: .harmoniaDark))
            } else {
                Color(UIColor(hexColor: .harmoniaDark).withAlphaComponent(0.5))

            }
        }
        
        Button {
            self.onClick()
        } label: {
            MKTextView(label: label, font: "Roboto-Bold", fontColor: textColor)
              .padding(.vertical, 10)
              .padding(.horizontal, 15)
        }
       .foregroundColor(.white)
       .background(bgColor)
       .cornerRadius(5)
       .disabled(!enabled)
    }
}
