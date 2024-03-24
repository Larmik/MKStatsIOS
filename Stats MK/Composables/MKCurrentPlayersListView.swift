//
//  MKCurrentPlayersListView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import SwiftUI

struct MKCurrentPlayersListView: View {
    
    let players: [CurrentPlayer]
    
    var splitIndex: Int {
        return switch(players.count % 2) {
        case 0: players.count / 2
        default: (players.count / 2) + 1
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    ForEach(players[0..<splitIndex]) { player in
                        //TODO old/new arrow
                        MKTextView(label: player.player?.name ?? "")
                            .frame(maxWidth: .infinity)
                        
                        
                    }.padding(.vertical, 0.1)
                        .frame(maxWidth: .infinity)
                } .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    ForEach(players[0..<splitIndex]) { player in
                        HStack(alignment: .center) {
                            MKTextView(label: "\(player.score)", font: "Montserrat-Bold")
                            if (player.shockCount > 0) {
                                Image("shock")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                
                                if (player.shockCount > 1) {
                                    MKTextView(label: "x\(player.shockCount)")
                                        .offset(x: -8)

                                }
                            }
                            Spacer()
                        } .frame(maxWidth: .infinity)
                        
                    }.padding(.vertical, 0.1)
                } .frame(maxWidth: .infinity)

            }            
            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 0))
            .frame(maxWidth: .infinity)
            
            
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    ForEach(players[splitIndex ..< players.count]) { player in
                        //TODO old/new arrow
                        MKTextView(label: player.player?.name ?? "")
                            .frame(maxWidth: .infinity)
                        
                        
                    }.padding(.vertical, 0.1)
                        .frame(maxWidth: .infinity)
                } .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    ForEach(players[splitIndex ..< players.count]) { player in
                        HStack(alignment: .center) {
                            MKTextView(label: "\(player.score)", font: "Montserrat-Bold")
                            if (player.shockCount > 0) {
                                Image("shock")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                
                                if (player.shockCount > 1) {
                                    MKTextView(label: "x\(player.shockCount)")
                                        .offset(x: -8)

                                }
                            }
                            Spacer()

                        } .frame(maxWidth: .infinity)
                        
                    }.padding(.vertical, 0.1)
                } .frame(maxWidth: .infinity)
            }
            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 0))
            .frame(maxWidth: .infinity)
        } .background(Color(UIColor(hexColor: .white).withAlphaComponent(0.5)))
        
    }
    
}
