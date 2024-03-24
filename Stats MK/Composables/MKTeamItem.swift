//
//  MKTeamItem.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/01/2024.
//

import SwiftUI

struct MKTeamItem: View {
    
    let team: MKCTeam
    let onClick: (String) -> Void
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                MKTextView(label: team.team_tag, font: "Montserrat-Bold", fontSize: 15, fontColor: Color(UIColor(hexColor: .white)))
                    .padding(.vertical, 5)
                    .lineLimit(1)
                Spacer()
            }.frame(width: 70)
                .background(Color(UIColor(intColor: teamColor(color: team.team_color))))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            ZStack {
                HStack {
                    MKTextView(label: team.team_name, font: "Montserrat-Bold", fontSize: 15)
                }.frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
        }.background(Color(UIColor(hexColor: .white).withAlphaComponent(0.5)))
            .onTapGesture {
                onClick(String(team.team_id))
            }
    }
    
}
