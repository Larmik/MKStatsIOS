//
//  MKCTeam.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation

struct MKCTeamResponse: Codable, Identifiable {
    
    var id = UUID()
    
    let count: Int
    let data: [MKCTeam]
    
    init(count: Int = 0, data: [MKCTeam] = [MKCTeam]()) {
        self.count = count
        self.data = data
    }
    private enum CodingKeys: String, CodingKey {
           case count, data
       }
}

struct MKCTeam: Codable, Identifiable {
        
    var id = UUID()
    
    let team_id: Int
    let team_name: String
    let team_tag: String
    let team_color: Int
    let team_status: String
    let recruitment_status: String
    let is_shadow: Int
    let player_count: Int
    let founding_date: String
    let founding_date_human: String
    
    init(team_id: Int, team_name: String, team_tag: String, team_color: Int, team_status: String, recruitment_status: String, is_shadow: Int, player_count: Int, founding_date: String, founding_date_human: String) {
        self.team_id = team_id
        self.team_name = team_name
        self.team_tag = team_tag
        self.team_color = team_color
        self.team_status = team_status
        self.recruitment_status = recruitment_status
        self.is_shadow = is_shadow
        self.player_count = player_count
        self.founding_date = founding_date
        self.founding_date_human = founding_date_human
    }
    
    init(sdTeam: SDTeam) {
        self.team_id = Int(sdTeam.id) ?? 0
        self.team_name = sdTeam.team_name ?? ""
        self.team_tag = sdTeam.team_tag ?? ""
        self.team_color = sdTeam.team_color ?? 0
        self.team_status = sdTeam.team_status ?? ""
        self.recruitment_status = sdTeam.recruitment_status ?? ""
        self.is_shadow = sdTeam.is_shadow ?? 0
        self.player_count = sdTeam.player_count ?? 0
        self.founding_date = sdTeam.founding_date ?? ""
        self.founding_date_human = sdTeam.founding_date ?? ""
    }
    private enum CodingKeys: String, CodingKey {
           case team_id, team_name, team_tag, team_color, team_status, recruitment_status, is_shadow, player_count, founding_date, founding_date_human
       }
}


struct MKCLightTeam: Codable, Identifiable {
        
    var id = UUID()
    
    let mode_title: String
    let mode_key: String
    let mode: String
    let team_id: Int
    let team_status: String
    let team_name: String
    let team_tag: String
    
    init(mode_title: String, mode_key: String, mode: String, team_id: Int, team_status: String, team_name: String, team_tag: String) {
        self.mode_title = mode_title
        self.mode_key = mode_key
        self.mode = mode
        self.team_id = team_id
        self.team_status = team_status
        self.team_name = team_name
        self.team_tag = team_tag
    }
    
   
    private enum CodingKeys: String, CodingKey {
       case mode_title, mode_key, mode, team_id, team_status, team_name, team_tag
    }
}


struct MKCFullTeam: Codable, Identifiable {
        
    var id: Int
    let primary_team_id: Int?
    let primary_team_name: String?
    let secondary_teams: [SecondaryTeam]?
    let founding_date: MKCDate
    let founding_date_human: String
    let team_category: String
    let team_name: String
    let team_tag: String
    let team_color: Int
    let team_description: String
    let team_logo: String
    let main_language: String
    let recruitment_status: String
    let team_status: String
    let is_historical: Int
    var rosters: [MKCLightPlayer]?
    
    
    init(team: MKCFullTeam, rosters: [MKCLightPlayer]) {
        self.id = team.id
        self.primary_team_id = team.primary_team_id
        self.primary_team_name = team.primary_team_name
        self.secondary_teams = team.secondary_teams
        self.founding_date = team.founding_date
        self.founding_date_human = team.founding_date_human
        self.team_category = team.team_category
        self.team_name = team.team_name
        self.team_tag = team.team_tag
        self.team_color = team.team_color
        self.team_description = team.team_description
        self.team_logo = team.team_logo
        self.main_language = team.main_language
        self.recruitment_status = team.recruitment_status
        self.team_status = team.team_status
        self.is_historical = team.is_historical
        self.rosters = rosters
    }
    
    private enum CodingKeys: String, CodingKey {
           case id, primary_team_id, primary_team_name, secondary_teams, founding_date, founding_date_human, team_category, team_name, team_tag, team_color, team_description, team_logo, main_language, recruitment_status, team_status, is_historical
       }
    
}

struct SecondaryTeam: Codable, Identifiable {
    var id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct MKCDate: Codable, Identifiable {
    var id = UUID()
    let date: String
    let timezone: String
    let timezone_type: Int
    
    init(date: String, timezone: String, timezone_type: Int) {
        self.date = date
        self.timezone = timezone
        self.timezone_type = timezone_type
    }
    
    private enum CodingKeys: String, CodingKey {
       case date, timezone, timezone_type
    }
}
