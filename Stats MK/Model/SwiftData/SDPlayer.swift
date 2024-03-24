//
//  MKPlayer.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation
import SwiftData

@Model
final class SDPlayer {
    @Attribute(.unique) let mid: String
    let mkcId: String
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
    let discordId: String
    
    init(user: FBUser, isAlly: Int) {
        self.mid = user.mid
        self.mkcId = user.mkcId ?? ""
        self.name = user.name ?? ""
        self.fc = ""
        self.status = ""
        self.registerDate = ""
        self.country = ""
        self.isLeader = (user.role ?? 0) >= 2 ? 1 : 0
        self.role = user.role ?? 0
        self.currentWar = user.currentWar ?? ""
        self.picture = user.picture ?? ""
        self.isAlly = isAlly
        self.discordId = user.discordId ?? ""
    }
    
    init (mkPlayer: SDPlayer, currentWar: String) {
        self.mid = mkPlayer.mid
        self.mkcId = mkPlayer.mkcId
        self.name = mkPlayer.name
        self.fc = mkPlayer.fc
        self.status = mkPlayer.status
        self.registerDate = mkPlayer.registerDate
        self.country = mkPlayer.country
        self.isLeader = mkPlayer.isLeader
        self.role = mkPlayer.role
        self.currentWar = currentWar
        self.picture = mkPlayer.picture
        self.isAlly = mkPlayer.isAlly
        self.discordId = mkPlayer.discordId
    }
    
    init(player: MKCFullPlayer?, mid: String, role: Int, isAlly: Int, isLeader: Int, currentWar: String, discordId: String) {
        self.mid = mid
        self.mkcId = String(player?.id ?? 0)
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
        self.discordId = discordId
    }
    
    init(mid: String, mkcId: Int, name: String, fc: String, status: String, registerDate: String, country: String, isLeader: Int, role: Int, currentWar: String, picture: String, isAlly: Int, discordId: String) {
        self.mid = mid
        self.mkcId = String(mkcId)
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
        self.discordId = discordId
    }
    
}

struct CurrentPlayer: Codable, Identifiable {
    var id = UUID()
    
    
    let player: MKCLightPlayer?
    let score: Int
    let old: Bool?
    let new: Bool?
    let shockCount: Int
    
    init(player: MKCLightPlayer?, score: Int, old: Bool?, new: Bool?, shockCount: Int) {
        self.player = player
        self.score = score
        self.old = old
        self.new = new
        self.shockCount = shockCount
    }
    
    
    init(player: MKCLightPlayer) {
        self.score = 0
        self.shockCount = 0
        self.old = nil
        self.new = nil
        self.player = player
    }
    
  
    
}

