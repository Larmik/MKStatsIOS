//
//  MKTeam.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation
import SwiftData
import RxSwift

@Model
final class SDTeam {
    
    @Attribute(.unique) let id: String
    let founding_date: String?
    let team_name: String?
    let team_tag: String?
    let team_color: Int?
    let recruitment_status: String?
    let team_status: String?
    let is_shadow: Int?
    let player_count: Int?
    
    init(team: FBTeam) {
        self.id = team.mid 
        self.founding_date = ""
        self.team_name = team.name ?? ""
        self.team_tag = team.shortName ?? ""
        self.team_color = 0
        self.recruitment_status = ""
        self.team_status = ""
        self.is_shadow = 0
        self.player_count = 0
    }
    
    init(mkcTeam: MKCTeam) {
        self.id = String(mkcTeam.team_id)
        self.founding_date = mkcTeam.founding_date
        self.team_name = mkcTeam.team_name
        self.team_tag = mkcTeam.team_tag
        self.team_color = mkcTeam.team_color
        self.recruitment_status = mkcTeam.recruitment_status
        self.team_status = mkcTeam.team_status
        self.is_shadow = mkcTeam.is_shadow
        self.player_count = mkcTeam.player_count
    }
    
    init(id: String, founding_date: String?, team_name: String?, team_tag: String?, team_color: Int?, recruitment_status: String?, team_status: String?, is_shadow: Int?, player_count: Int?) {
        self.id = id
        self.founding_date = founding_date
        self.team_name = team_name
        self.team_tag = team_tag
        self.team_color = team_color
        self.recruitment_status = recruitment_status
        self.team_status = team_status
        self.is_shadow = is_shadow
        self.player_count = player_count
    }
}
