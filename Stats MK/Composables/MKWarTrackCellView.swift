//
//  MKWarTrackCellView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import SwiftUI

struct MKWarTrackCellView: View {
    
    let track: MKWarTrack?
    let isVertical: Bool
    let map: Maps
    let shocks: [String]
    let onClick: () -> Void
    let showCup: Bool
    
    init(track: MKWarTrack? = nil, map: Maps? = nil, isVertical: Bool = false, showCup: Bool = false, onClick: @escaping () -> Void) {
        self.track = track
        self.isVertical = isVertical
        self.map = map ?? Maps.allCases[track?.trackIndex ?? 0]
        let shockCount = track?.shocks.map { $0.count }.reduce(0, +) ?? 0
        var images = [String]()
        if (shockCount > 0) {
            for _ in 1...shockCount {
                images.append("shock")
            }
        }
        self.shocks = images
        self.onClick = onClick
        self.showCup = showCup
    }
    
    var body: some View {
        let borderColor = if ((track?.diffScore ?? 0) > 0) {
            Color(UIColor(hexColor: .win))

        }
        else if ((track?.diffScore ?? 0) < 0) {
            Color(UIColor(hexColor: .lose))

        }
        else  {
            Color.white
        }
        
      
        
        if (isVertical) {
            VStack(alignment: .center) {
                Image(map.picture)
                    .resizable()
                    .frame(width: 90, height: 50)
                    .cornerRadius(5)
                MKTextView(label: map.label, font: "Montserrat-Bold", fontSize: 14)
                MKTextView(label: map.rawValue, fontSize: 11)
                if (track != nil) {
                    MKScoreView(track: track!, isSmaller: true)
                }
                
            }.frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(UIColor.white.withAlphaComponent(0.5)))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 2)
                )
                .onTapGesture {
                    onClick()
                }
            
        } else {
            HStack {
                Image(map.picture)
                    .resizable()
                    .frame(width: 90, height: 50)
                    .cornerRadius(5)
                HStack {
                    VStack(alignment: .leading) {
                        MKTextView(label: map.label, font: "Montserrat-Bold", fontSize: 14)
                        MKTextView(label: map.rawValue, fontSize: 11)
                    }
                    Spacer()
                }.frame(maxWidth: .infinity)
                
             
                if (track != nil) {
                    if (showCup) {
                        Image(map.cupPicture)
                            .resizable()
                            .frame(width: 30, height: 30)
                    } else {
                        HStack {
                            ForEach(shocks, id: \.self) {
                                Image($0)
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }

                        }
                        MKScoreView(track: track!, isSmaller: true)
                    }

                }
                
            }.frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(UIColor.white.withAlphaComponent(0.5)))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 2)
                )
                .onTapGesture {
                    onClick()
                }
        }
      
    
    }
}
