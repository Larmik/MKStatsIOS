//
//  MKCurrentWarCellView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import SwiftUI

struct MKCurrentWarCellView: View {
    
    let war: MKWar
    let teamName: String
    let opponentName: String
    let teamScore: String
    let opponentScore: String
    let remaining: Int
    let diff: String
    let diffColor: Colors
    let onClick: () -> Void
    let state: String?
    
    init(war: MKWar, state: String?, onClick: @escaping () -> Void) {
        self.war = war
        self.onClick = onClick
        self.state = state
        self.teamName = String(war.warName?.split(separator: "-")[0] as? Substring ?? "")
        self.opponentName = String(war.warName?.split(separator: "-")[1] as? Substring ?? "")
        self.teamScore = String(war.displayedScore.split(separator: "-")[0])
        self.opponentScore = String(war.displayedScore.split(separator: "-")[1])
        self.diff = war.displayedDiff
        self.remaining = 12 - (war.trackPlayed)
        self.diffColor = switch (true) {
        case war.displayedDiff.contains("+"): Colors.win
        case war.displayedDiff.contains("-"): Colors.lose
        default: Colors.white
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if (state != nil) {
                ProgressView( label: {
                    MKTextView(label: state!,  fontSize: 14, fontColor:  Color(UIColor(hexColor: .white)))
                }).progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(hexColor: .white))))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 20)
            } else {
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        MKTextView(label: teamName, font: "Montserrat-Bold", fontSize: 16, fontColor: Color.white).lineLimit(1)
                            .padding(.vertical, 5)
                        MKTextView(label: teamScore, font: "Orbitron-SemiBold", fontSize: 22, fontColor: Color.white).lineLimit(1)
                    }.frame(maxWidth: .infinity)
                    MKTextView(label: diff, font: "Orbitron-SemiBold", fontSize: 18, fontColor: Color(UIColor(hexColor: diffColor))).lineLimit(1)
                    VStack(alignment: .center) {
                        MKTextView(label: opponentName, font: "Montserrat-Bold", fontSize: 16, fontColor: Color.white).lineLimit(1)
                            .padding(.vertical, 5)
                        MKTextView(label: opponentScore, font: "Orbitron-SemiBold", fontSize: 22, fontColor: Color.white).lineLimit(1)
                    }.frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
                MKTextView(label: "Maps restantes: \(remaining)", fontSize: 12, fontColor: Color.white).lineLimit(1)
            }
          
        }.padding(10)
            .cornerRadius(5)
            .background(Color(UIColor(hexColor: .harmoniaDark)))
            .frame(maxWidth: .infinity)
            .onTapGesture {
                onClick()
            }
    }
}

