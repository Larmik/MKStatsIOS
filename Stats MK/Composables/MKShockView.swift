//
//  MKShockView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 23/01/2024.
//

import SwiftUI

struct MKShockView: View {
    
    let tracks: [MKWarTrack]
    let total: Int
    
    init(tracks: [MKWarTrack]) {
        self.tracks = tracks
        var total = 0
        tracks.forEach {
            $0.shocks.forEach{
                total += $0.count
            }
        }
        self.total = total
    }
    
    var body: some View {
        if (total > 0) {
            HStack(alignment: .center) {
                Spacer()
                Image("shock")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                MKTextView(label: "x\(total)", font: "Orbitron-SemiBold", fontSize: 16)
                    .offset(x: -10)
            }.frame(maxWidth: .infinity)
                .padding(.trailing, 10)
        }
    }
}
