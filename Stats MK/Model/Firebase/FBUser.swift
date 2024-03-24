//
//  User.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation

struct FBUser: Codable, Identifiable {
    var id = UUID()
    
    let mid: String
    let name: String?
    let currentWar: String?
    let role: Int?
    let picture: String?
    let mkcId: String?
    let discordId: String?
    
    init(mid: String, name: String?, currentWar: String?, role: Int?, picture: String?, mkcId: String?, discordId: String?) {
        self.mid = mid
        self.name = name
        self.currentWar = currentWar
        self.role = role
        self.picture = picture
        self.mkcId = mkcId
        self.discordId = discordId
    }
    
    init(sdPlayer: SDPlayer) {
        self.mid = sdPlayer.mid
        self.name = sdPlayer.name
        self.currentWar = sdPlayer.currentWar
        self.role = sdPlayer.role
        self.picture = sdPlayer.picture
        self.mkcId = sdPlayer.mkcId
        self.discordId = sdPlayer.discordId
    }
    
    
    init(player: MKCLightPlayer?, mid: String, discordId: String?, currentWar: String?) {
        self.mid = mid 
        self.name = player?.name
        self.currentWar = currentWar
        self.role = player?.role
        self.picture = player?.picture
        self.mkcId = String(player?.mkcId ?? 0)
        self.discordId = discordId
    }
    
    private enum CodingKeys: String, CodingKey {
       case mid, name, currentWar, role, picture, mkcId, discordId
    }
}

