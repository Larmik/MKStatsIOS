//
//  MKScoreView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import SwiftUI

struct MKScoreView: View {
    
    let track: MKWarTrack?
    let war: MKWar?
    let padding: CGFloat
    let fontSize: CGFloat
    let subFontSize: CGFloat
    let subFontColor: Colors
    
    init(track: MKWarTrack? = nil, war: MKWar? = nil, isSmaller: Bool = false) {
        self.track = track
        self.war = war
        if isSmaller {
            self.padding = 0
            self.fontSize = 14
            self.subFontSize = 11
        }
        else {
            self.padding = 10
            self.fontSize = 22
            self.subFontSize = 18
        }
        if (isSmaller) {
            self.subFontColor = .black

        }
        else if (war?.displayedDiff.contains("+") ?? track?.displayedDiff.contains("+") ?? false) {
            self.subFontColor = .win
        } else if (war?.displayedDiff.contains("-") ?? track?.displayedDiff.contains("-") ?? false) {
            self.subFontColor = .lose
        } else {
            self.subFontColor = .black
        }
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            MKTextView(label: track?.displayedResult ?? war?.displayedScore ?? "" , font: "Orbitron-SemiBold", fontSize: fontSize)
                .padding(.horizontal, padding)
            MKTextView(label: track?.displayedDiff ?? war?.displayedDiff ?? "", font: "Orbitron-Regular", fontSize: subFontSize, fontColor: Color(UIColor(hexColor: subFontColor)))
                .padding(.horizontal, padding)
        }
    }
}
