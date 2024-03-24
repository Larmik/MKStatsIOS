//
//  MKCPlayer.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation

struct KCPlayerResponse: Codable, Identifiable {
    
    var id = UUID()
    
    let count: Int
    let data: [MKCPlayer]
    
    init(count: Int = 0, data: [MKCPlayer] = [MKCPlayer]()) {
        self.count = count
        self.data = data
    }
    private enum CodingKeys: String, CodingKey {
           case count, data
       }
}

struct MKCLightPlayer: Codable, Identifiable {
    var id = UUID()
    
    let mkcId: Int
    let name: String
    let fc: String
    let status: String
    let registerDate: String
    let country: String
    let isLeader: Int
    let role: Int
    var currentWar: String
    let picture: String
    let isAlly: Int
    
    init(player: MKCFullPlayer?, role: Int, isAlly: Int, isLeader: Int, currentWar: String) {
        self.mkcId = player?.id ?? 0
        self.name = player?.display_name ?? ""
        self.fc = player?.switch_fc ?? ""
        self.status = player?.player_status ?? ""
        self.registerDate = player?.registered_at.date ?? ""
        self.country = player?.country_code ?? ""
        self.isLeader = isLeader
        self.role = role
        self.currentWar = currentWar
        self.picture = player?.profile_picture  ?? ""
        self.isAlly = isAlly
    }
    
    init(mkPlayer: SDPlayer?) {
        self.mkcId = Int(mkPlayer?.mkcId ?? "") ?? 0
        self.name = mkPlayer?.name ?? ""
        self.fc = mkPlayer?.fc ?? ""
        self.status = mkPlayer?.status ?? ""
        self.registerDate = mkPlayer?.registerDate ?? ""
        self.country = mkPlayer?.country ?? "0"
        self.isLeader = mkPlayer?.isLeader ?? 0
        self.role = mkPlayer?.role ?? 0
        self.currentWar = mkPlayer?.currentWar ?? ""
        self.picture = mkPlayer?.picture ?? ""
        self.isAlly = mkPlayer?.isAlly ?? 0
    }
    
    init(lightPlayer: MKCLightPlayer?, currentWar: String) {
        self.mkcId = lightPlayer?.mkcId ?? 0
        self.name = lightPlayer?.name ?? ""
        self.fc = lightPlayer?.fc ?? ""
        self.status = lightPlayer?.status ?? ""
        self.registerDate = lightPlayer?.registerDate ?? ""
        self.country = lightPlayer?.country ?? ""
        self.isLeader = lightPlayer?.isLeader ?? 0
        self.role = lightPlayer?.role ?? 0
        self.currentWar = currentWar
        self.picture = lightPlayer?.picture ?? ""
        self.isAlly = lightPlayer?.isAlly ?? 0
    }
    
    init(mkcId: Int, name: String, fc: String, status: String, registerDate: String, country: String, isLeader: Int, role: Int, currentWar: String, picture: String, isAlly: Int) {
        self.mkcId = mkcId
        self.name = name
        self.fc = fc
        self.status = status
        self.registerDate = registerDate
        self.country = country
        self.isLeader = isLeader
        self.role = role
        self.currentWar = currentWar
        self.picture = picture
        self.isAlly = isAlly
    }
    
    private enum CodingKeys: String, CodingKey {
           case mkcId, name, fc, status, registerDate, country, isLeader, role, currentWar, picture, isAlly
       }

}

struct MKCPlayer: Codable, Identifiable {
    var id = UUID()
    
    let player_id: Int
    let user_id: Int
    let display_name: String
    let custom_field: String?
    let custom_field_name: String?
    let switch_fc: String?
    let nnid: String?
    let fc_3ds: String?
    let mktour_fc: String?
    let player_status: String
    let registered_at: String
    let registered_at_human: String
    let team_registered_at: String?
    let team_registered_at_human: String?
    let country_code: String
    let country_name: String
    
    init(player_id: Int, user_id: Int, display_name: String, custom_field: String?, custom_field_name: String?, switch_fc: String?, nnid: String?, fc_3ds: String?, mktour_fc: String?, player_status: String, registered_at: String, registered_at_human: String, team_registered_at: String?, team_registered_at_human: String?, country_code: String, country_name: String) {
        self.player_id = player_id
        self.user_id = user_id
        self.display_name = display_name
        self.custom_field = custom_field
        self.custom_field_name = custom_field_name
        self.switch_fc = switch_fc
        self.nnid = nnid
        self.fc_3ds = fc_3ds
        self.mktour_fc = mktour_fc
        self.player_status = player_status
        self.registered_at = registered_at
        self.registered_at_human = registered_at_human
        self.team_registered_at = team_registered_at
        self.team_registered_at_human = team_registered_at_human
        self.country_code = country_code
        self.country_name = country_name
    }
    
    private enum CodingKeys: String, CodingKey {
           case player_id, user_id, display_name, custom_field, custom_field_name, switch_fc, nnid, fc_3ds, mktour_fc, player_status, registered_at, registered_at_human,
                team_registered_at, team_registered_at_human, country_code, country_name
       }
}

struct MKCFullPlayer: Codable, Identifiable {
    
    var id: Int
    let user_id: Int
    let registered_at: MKCDate
    let registered_at_human: String
    let display_name: String
    let player_status: String
    let is_banned: Bool
    let ban_reason: String?
    let is_hidden: Int
    let country_code: String
    let country_name: String
    let region: String?
    let city: String?
    let discord_privacy: String?
    let discord_tag: String?
    let switch_fc: String?
    let nnid: String?
    let fc_3ds: String?
    let mktour_fc: String?
    let profile_picture: String?
    let profile_picture_border_color: Int
    let profile_message: String?
    let is_supporter: Bool
    let is_administrator: Bool
    let is_moderator: Bool
    let is_global_event_admin: Bool
    let is_global_event_mod: Bool
    let is_event_admin: Bool
    let is_event_mod: Bool
    let current_teams: [MKCLightTeam]
    
    init(id: Int, user_id: Int, registered_at: MKCDate, registered_at_human: String, display_name: String, player_status: String, is_banned: Bool, ban_reason: String?, is_hidden: Int, country_code: String, country_name: String, region: String?, city: String?, discord_privacy: String?, discord_tag: String?, switch_fc: String?, nnid: String?, fc_3ds: String?, mktour_fc: String?, profile_picture: String?, profile_picture_border_color: Int, profile_message: String?, is_supporter: Bool, is_administrator: Bool, is_moderator: Bool, is_global_event_admin: Bool, is_global_event_mod: Bool, is_event_admin: Bool, is_event_mod: Bool, current_teams: [MKCLightTeam]) {
        self.id = id
        self.user_id = user_id
        self.registered_at = registered_at
        self.registered_at_human = registered_at_human
        self.display_name = display_name
        self.player_status = player_status
        self.is_banned = is_banned
        self.ban_reason = ban_reason
        self.is_hidden = is_hidden
        self.country_code = country_code
        self.country_name = country_name
        self.region = region
        self.city = city
        self.discord_privacy = discord_privacy
        self.discord_tag = discord_tag
        self.switch_fc = switch_fc
        self.nnid = nnid
        self.fc_3ds = fc_3ds
        self.mktour_fc = mktour_fc
        self.profile_picture = profile_picture
        self.profile_picture_border_color = profile_picture_border_color
        self.profile_message = profile_message
        self.is_supporter = is_supporter
        self.is_administrator = is_administrator
        self.is_moderator = is_moderator
        self.is_global_event_admin = is_global_event_admin
        self.is_global_event_mod = is_global_event_mod
        self.is_event_admin = is_event_admin
        self.is_event_mod = is_event_mod
        self.current_teams = current_teams
    }

}

