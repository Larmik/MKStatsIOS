//
//  NewWar.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import SwiftData


struct FBWar: Codable, Identifiable {
    
    var id = UUID()
    
    let mid: String
    let playerHostId: String
    let teamHost: String
    let teamOpponent: String
    let createdDate: String
    var warTracks: [FBWarTrack]
    let penalties:  [FBPenalty]
    let isOfficial: Bool
    
    init(mid: String, playerHostId: String, teamHost: String, teamOpponent: String, createdDate: String, warTracks: [FBWarTrack], penalties: [FBPenalty], isOfficial: Bool) {
        self.mid = mid
        self.playerHostId = playerHostId
        self.teamHost = teamHost
        self.teamOpponent = teamOpponent
        self.createdDate = createdDate
        self.warTracks = warTracks
        self.penalties = penalties
        self.isOfficial = isOfficial
    }
    
    init(war: MKWar)  {
        self.mid = war.mid
        self.playerHostId = war.playerHostId
        self.teamHost = war.teamHost
        self.teamOpponent = war.teamOpponent
        self.createdDate = war.createdDate
        self.warTracks = war.warTracks.map { FBWarTrack(warTrack: $0)}
        self.penalties = war.penalties.map { FBPenalty(penalty: $0)}
        self.isOfficial = war.isOfficial
    }
}

struct FBWarTrack: Codable {
    let mid: String?
    var trackIndex: Int
    let warPositions: [FBWarPosition]?
    let shocks: [FBShock]?
    
    init(mid: String?, trackIndex: Int, warPositions: [FBWarPosition]?, shocks: [FBShock]?) {
        self.mid = mid
        self.trackIndex = trackIndex
        self.warPositions = warPositions
        self.shocks = shocks
    }
    
    init(mkWarTrack: SDWarTrack)  {
        self.mid = mkWarTrack.mid
        self.trackIndex = mkWarTrack.trackIndex
        self.warPositions = mkWarTrack.warPositions?.map { FBWarPosition(mkWarPosition: $0)  }
        self.shocks = mkWarTrack.shocks?.map {  FBShock(mkShock: $0) }
    }
    
    init(warTrack: MKWarTrack) {
        self.mid = warTrack.mid
        self.trackIndex = warTrack.trackIndex
        self.warPositions = warTrack.warPositions.map { FBWarPosition(warPosition: $0)  }
        self.shocks = warTrack.shocks.map { FBShock(shock: $0)  }
    }
    
    func toSnapshot() -> [String: Any] {
        return [
            "mid" : self.mid! as String,
            "trackIndex" : self.trackIndex,
            "warPositions" : self.warPositions?.map { $0.toSnapshot()  } as Any,
            "shocks" : self.shocks?.map {  $0.toSnapshot()  } as Any
        ]
    }
}

struct FBPenalty: Codable {
    let teamId: String
    let teamTag: String
    let amount: Int
    
    init(teamId: String, teamTag: String = "", amount: Int) {
        self.teamId = teamId
        self.teamTag = teamTag
        self.amount = amount
    }
    
    init(penalty: MKPenalty) {
        self.teamId = penalty.teamId
        self.teamTag = penalty.teamTag
        self.amount = penalty.amount
    }
    
    func toSnapshot() -> [String: Any] {
        return [
            "teamId" : self.teamId,
            "amount" : self.amount
        ]
    }
    
}

struct FBWarPosition: Codable {
    let mid: String?
        let playerId: String?
        let position: Int?
    
    init(mid: String?, playerId: String?, position: Int?) {
        self.mid = mid
        self.playerId = playerId
        self.position = position
    }
    init(mkWarPosition: SDWarPosition) {
        self.mid = ""
        self.playerId = mkWarPosition.playerId
        self.position = mkWarPosition.position
    }
    init(warPosition: MKWarPosition) {
        self.mid = warPosition.mid
        self.playerId = warPosition.playerId
        self.position = warPosition.position
    }
    
    func toSnapshot() -> [String : Any] {
        return [
            "mid" : self.mid! as String,
            "playerId" : self.playerId! as String,
            "position" : self.position! as Int
        ]
    }
}

struct FBShock: Codable {
    let playerId: String?
        let count: Int
    
    init(playerId: String?, count: Int) {
        self.playerId = playerId
        self.count = count
    }
    
    init(mkShock: SDShock) {
        self.playerId = mkShock.playerId
        self.count = mkShock.count
    }
    
    init(shock: MKShock) {
        self.playerId = shock.playerId
        self.count = shock.count
    }
    
    func toSnapshot() -> [String : Any] {
        return [
            "playerId" : self.playerId! as String,
            "count" : self.count
        ]
    }
}
