//
//  MKWar.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import SwiftData
import RxSwift

@Model
final class SDWar {
    @Attribute(.unique) let mid: String
    var warName: String?
    let playerHostId: String
    let teamHost: String
    let teamOpponent: String
    let createdDate: String
    @Relationship var warTracks: [SDWarTrack]?
    @Relationship var penalities: [SDPenalty]?
    let isOfficial: Bool
  
    
    
    init(newWar: FBWar, name: String) {
   
        
        self.mid = newWar.mid
        self.warName = name
        self.playerHostId = newWar.playerHostId
        self.teamHost = newWar.teamHost
        self.teamOpponent = newWar.teamOpponent
        self.createdDate = newWar.createdDate
        self.warTracks = newWar.warTracks.map { SDWarTrack(track: $0)}
        self.penalities = newWar.penalties.map { SDPenalty(penalty: $0)}
        self.isOfficial = newWar.isOfficial
     
    }
    
    func hasTeam(team: String) -> Bool {
        return self.teamHost == team || self.teamOpponent == team
    }
    
}

@Model
final class SDWarTrack {
    @Attribute(.unique) let mid: String
    var trackIndex: Int
    @Relationship var warPositions: [SDWarPosition]?
    @Relationship var shocks: [SDShock]?
   
    
    init(track: FBWarTrack) {
        
      
        self.mid = track.mid!
        self.trackIndex = track.trackIndex
        self.warPositions = track.warPositions.map { pos in pos.map {
            SDWarPosition(position: $0)
        } } ?? []
        self.shocks = track.shocks.map { shocks in shocks.map{ SDShock(shock: $0)} } ?? []
     
        
    }
    
}

@Model
final class SDPenalty {
    @Attribute(.unique) let id = UUID()
    let teamId: String
    let teamTag: String
    let amount: Int
    
    init(penalty: FBPenalty) {
        self.teamId = penalty.teamId
        self.teamTag = penalty.teamTag
        self.amount = penalty.amount
    }
}

@Model
final class SDWarPosition {
    @Attribute(.unique) let id = UUID()
    let mid: String?
    let playerId: String?
    let position: Int?
    
    init(position: FBWarPosition) {
        self.mid = position.mid
        self.playerId = position.playerId
        self.position = position.position
    }
}

@Model
final class SDShock {
    @Attribute(.unique) let id = UUID()
    let playerId: String?
    let count: Int
    
    init(shock: FBShock) {
        self.playerId = shock.playerId
        self.count = shock.count
    }
}
