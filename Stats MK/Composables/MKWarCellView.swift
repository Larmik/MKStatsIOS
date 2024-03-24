//
//  MKWarCellView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 21/01/2024.
//

import SwiftUI

struct MKWarCellView: View {
    
    let war: MKWar
    let onWarClick: (String) -> Void
    
    
    var body: some View {
        let borderColor = if (war.displayedDiff.contains("+")) {
            Color(UIColor(hexColor: .win))

        }
        else if ((war.displayedDiff.contains("-"))) {
            Color(UIColor(hexColor: .lose))

        }
        else  {
            Color.white
        }
        HStack {
            VStack {
                MKTextView(label: war.warName!, font: "Montserrat-Bold", fontSize: 16)
                MKTextView(label: war.createdDate)
            }.frame(maxWidth: .infinity)
            HStack {
                VStack(alignment: .leading) {
                    MKTextView(label: "Score: ", fontSize: 12)
                    MKTextView(label: "Diff: ", fontSize: 12)
                    MKTextView(label: "Maps: ", fontSize: 12)
                }
                VStack(alignment: .leading) {
                    MKTextView(label: war.displayedScore, font: "Montserrat-Bold", fontSize: 12)
                    MKTextView(label: war.displayedDiff, font: "Montserrat-Bold", fontSize: 12)
                    MKTextView(label: war.mapsWon, font: "Montserrat-Bold", fontSize: 12)
                }
            }.frame(width: 130)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor(.white).withAlphaComponent(0.5)))
        .cornerRadius(5)
        .onTapGesture {
            onWarClick(war.mid)
        }
        .overlay(
                   RoundedRectangle(cornerRadius: 5)
                       .stroke(borderColor, lineWidth: 2)
               )    }
}
