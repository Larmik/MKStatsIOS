//
//  CurrentWar.swift
//  Stats MK
//
//  Created by Pascal Alberti on 23/01/2024.
//

import Foundation

struct MKWar : Codable, Identifiable {
    
    var id = UUID()
    
    
    let playerHostId: String
    let teamHost: String
    let teamOpponent: String
    let createdDate: String
    let isOfficial: Bool
    
    let mid: String
    var warName: String?
    var warTracks: [MKWarTrack]
    var penalties : [MKPenalty]
    let trackPlayed: Int
    let scoreHost: Int
    private let scoreHostWithPenalties: Int
    private let scoreOpponent: Int
    private let scoreOpponentWithPenalties: Int
    let isOver: Bool
    let displayedScore: String
    let mapsWon: String
    let displayedState: String
    let displayedDiff: String
    
    init(sdWar: SDWar) {
        let tracks = sdWar.warTracks?.map {  MKWarTrack(sdWarTrack: $0) } ?? []
        let penas = sdWar.penalities?.map {  MKPenalty(sdPenalty: $0)} ?? []
        let hostScore = tracks.map { $0.teamScore }.reduce(0, +)
        let opponentScore =  (82 * tracks.count) - hostScore
        let hostScoreWithPenas = hostScore - penas.filter { $0.teamId == sdWar.teamHost }.map { $0.amount }.reduce(0, +)
        let opponentScoreWithPenas = opponentScore - penas.filter { $0.teamId == sdWar.teamOpponent }.map { $0.amount }.reduce(0, +)
        let diff = hostScoreWithPenas - opponentScoreWithPenas
        
        self.mid = sdWar.mid
        self.createdDate = sdWar.createdDate
        self.warName = sdWar.warName
        self.warTracks = tracks
        self.penalties = penas
        self.trackPlayed = tracks.count
        self.scoreHost = hostScore
        self.scoreHostWithPenalties = hostScoreWithPenas
        self.scoreOpponent = opponentScore
        self.scoreOpponentWithPenalties = opponentScoreWithPenas
        self.isOver = tracks.count == 12
        self.displayedScore = "\(hostScoreWithPenas) - \(opponentScoreWithPenas)"
        self.mapsWon = "\(tracks.filter{ $0.diffScore > 0 }.count) / 12"
        
        if (tracks.count == 12) {
            self.displayedState = "War terminée"
        } else {
            self.displayedState = "War en cours (\(tracks.count) / 12)"
        }
        if (diff > 0) {
            self.displayedDiff = "+\(diff)"
        } else {
            self.displayedDiff = "\(diff)"
        }
        
        self.playerHostId = sdWar.playerHostId
        self.teamHost = sdWar.teamHost
        self.teamOpponent = sdWar.teamOpponent
        self.isOfficial = sdWar.isOfficial
    }
    
    init(newWar: FBWar) {
        
        let tracks = newWar.warTracks.map { MKWarTrack(fbWarTrack: $0)}
        let penas = newWar.penalties.map { MKPenalty(fbPenalty: $0)}
        let hostScore = tracks.map { $0.teamScore }.reduce(0, +)
        let opponentScore =  (82 * tracks.count) - hostScore
        let hostScoreWithPenas = hostScore - penas.filter { $0.teamId == newWar.teamHost }.map { $0.amount }.reduce(0, +)
        let opponentScoreWithPenas = opponentScore - penas.filter { $0.teamId == newWar.teamOpponent }.map { $0.amount }.reduce(0, +)
        let diff = hostScoreWithPenas - opponentScoreWithPenas
        
        self.mid = newWar.mid
        self.createdDate = newWar.createdDate
        self.warName = ""
        self.warTracks = tracks
        self.penalties = penas
        self.trackPlayed = tracks.count
        self.scoreHost = hostScore
        self.scoreHostWithPenalties = hostScoreWithPenas
        self.scoreOpponent = opponentScore
        self.scoreOpponentWithPenalties = opponentScoreWithPenas
        self.isOver = tracks.count == 12
        self.displayedScore = "\(hostScoreWithPenas) - \(opponentScoreWithPenas)"
        self.mapsWon = "\(tracks.filter{ $0.diffScore > 0 }.count) / 12"
        
        if (tracks.count == 12) {
            self.displayedState = "War terminée"
        } else {
            self.displayedState = "War en cours (\(tracks.count) / 12)"
        }
        if (diff > 0) {
            self.displayedDiff = "+\(diff)"
        } else {
            self.displayedDiff = "\(diff)"
        }
        
        self.playerHostId = newWar.playerHostId
        self.teamHost = newWar.teamHost
        self.teamOpponent = newWar.teamOpponent
        self.isOfficial = newWar.isOfficial
    }
    
    
}

struct MKPenalty: Codable, Identifiable {
    
    var id = UUID()
    let teamId: String
    let teamTag: String
    let amount: Int
    
    init(teamId: String, teamTag: String, amount: Int) {
        self.teamId = teamId
        self.teamTag = teamTag
        self.amount = amount
    }
    
    init(sdPenalty: SDPenalty) {
        self.teamId = sdPenalty.teamId
        self.teamTag = sdPenalty.teamTag
        self.amount = sdPenalty.amount
    }
    
    init(fbPenalty: FBPenalty) {
        self.teamId = fbPenalty.teamId
        self.teamTag = fbPenalty.teamTag
        self.amount = fbPenalty.amount
    }

    
}

struct MKWarTrack: Codable, Identifiable {
    var id = UUID()
    
    let mid: String
    var trackIndex: Int
    var warPositions: [MKWarPosition]
    var shocks: [MKShock]
    let teamScore: Int
    let opponentScore: Int
    let diffScore: Int
    let displayedResult: String
    let displayedDiff: String
    
    init(mid: String, index: Int, positions: [MKWarPosition]) {
        
        var scoreOpponent = 0
        var scoreDiff = 0
        
        let scoreTeam = positions.map { positionToPoints(pos: $0.position) }.reduce(0, +)
        if (scoreTeam != 0) {
            scoreOpponent = 82 - scoreTeam
            scoreDiff = scoreTeam - scoreOpponent
        }
        var displayedDiff: String {
            if (scoreDiff > 0) {
                return "+\(scoreDiff)"
            }
            else {
                return "\(scoreDiff)"
            }
        }
        
        self.mid = mid
        self.trackIndex = index
        self.warPositions = positions
        self.shocks = []
        self.teamScore = scoreTeam
        self.opponentScore = scoreOpponent
        self.diffScore = scoreDiff
        self.displayedResult = "\(scoreTeam) - \(scoreOpponent)"
        self.displayedDiff = displayedDiff
    }
    
    init(map: Maps) {
        self.mid = map.rawValue
        self.trackIndex = map.trackIndex
        self.warPositions = []
        self.shocks = []
        self.teamScore = 0
        self.opponentScore = 0
        self.diffScore = 0
        self.displayedResult = ""
        self.displayedDiff = ""
    }
    
    init(sdWarTrack: SDWarTrack) {
        var scoreOpponent = 0
        var scoreDiff = 0
        
        let positions =  sdWarTrack.warPositions
        let scoreTeam = positions?.map {  positionToPoints(pos: $0.position) }.reduce(0, +) ?? 0
        if (scoreTeam != 0) {
            scoreOpponent = 82 - scoreTeam
            scoreDiff = scoreTeam - scoreOpponent
        }
        var displayedDiff: String {
            if (scoreDiff > 0) {
                return "+\(scoreDiff)"
            }
            else {
                return "\(scoreDiff)"
            }
        }
        self.mid = sdWarTrack.mid
        self.trackIndex = sdWarTrack.trackIndex
        self.warPositions = sdWarTrack.warPositions?.map { MKWarPosition(sdPosition: $0) } ?? []
        self.shocks = sdWarTrack.shocks?.map { MKShock(sdShock: $0) } ?? []
        self.teamScore = scoreTeam
        self.opponentScore = scoreOpponent
        self.diffScore = scoreDiff
        self.displayedResult = "\(scoreTeam) - \(scoreOpponent)"
        self.displayedDiff = displayedDiff
    }
    
    init(fbWarTrack: FBWarTrack) {
        var scoreOpponent = 0
        var scoreDiff = 0
        
        let positions =  fbWarTrack.warPositions.map { position in position.map{ SDWarPosition(position: $0) } } ?? [SDWarPosition]()
        let scoreTeam = positions.map { positionToPoints(pos: $0.position) }.reduce(0, +)
        if (scoreTeam != 0) {
            scoreOpponent = 82 - scoreTeam
            scoreDiff = scoreTeam - scoreOpponent
        }
        var displayedDiff: String {
            if (scoreDiff > 0) {
                return "+\(scoreDiff)"
            }
            else {
                return "\(scoreDiff)"
            }
        }
        self.mid = fbWarTrack.mid ?? ""
        self.trackIndex = fbWarTrack.trackIndex
        self.warPositions = fbWarTrack.warPositions.map{ position in position.map { MKWarPosition(fbPosition: $0) } } ?? []
        self.shocks = fbWarTrack.shocks.map { shock in shock.map { MKShock(fbShock: $0)} } ?? []
        self.teamScore = scoreTeam
        self.opponentScore = scoreOpponent
        self.diffScore = scoreDiff
        self.displayedResult = "\(scoreTeam) - \(scoreOpponent)"
        self.displayedDiff = displayedDiff
    }
    
}

struct MKWarPosition: Codable, Identifiable {
    var id = UUID()
    
    let mid: String?
    let playerId: String?
    let position: Int?
    
    init(sdPosition: SDWarPosition) {
        self.mid = sdPosition.mid
        self.playerId = sdPosition.playerId
        self.position = sdPosition.position
    }
    
    init(fbPosition: FBWarPosition) {
        self.mid = fbPosition.mid
        self.playerId = fbPosition.playerId
        self.position = fbPosition.position
    }
}

struct MKShock: Codable, Identifiable {
    var id = UUID()
    
    let playerId: String?
    let count: Int
    
    init(playerId: String, count: Int) {
        self.playerId = playerId
        self.count = count
    }
    
    init(sdShock: SDShock) {
        self.playerId = sdShock.playerId
        self.count = sdShock.count
    }
    
    init(fbShock: FBShock) {
        self.playerId = fbShock.playerId
        self.count = fbShock.count
    }
}


struct MKPlayerWarPosition: Identifiable {
    var id = UUID()
    let position: MKWarPosition
    let mkcPlayer: SDPlayer?
}

