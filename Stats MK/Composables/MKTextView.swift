//
//  MKTextView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import SwiftUI

struct MKTextView: View {
    
    let label: String
    var fontName = "Montserrat-Regular"
    var fontSize: CGFloat = 13
    var fontColor = Color.black
    
    init(label: String, font: String = "Montserrat-Regular", fontSize: CGFloat = 13, fontColor: Color = .black) {
        self.label = label
        self.fontName = font
        self.fontSize = fontSize
        self.fontColor = fontColor
    }
    
    var body: some View {
        Text(label)
            .foregroundStyle(fontColor)
            .font(.custom(fontName, size: fontSize))
    }
}

