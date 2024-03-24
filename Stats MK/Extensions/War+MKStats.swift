//
//  War+MKStats.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import Foundation
import RxSwift


@MainActor func withName(warList: [FBWar], database: DatabaseRepository, onFinish: @escaping () -> Void) {
    var finalList = [SDWar]()
    warList.forEach {  war in
        Observable
            .zip(database.team(id: war.teamHost),database.team(id: war.teamOpponent))
            .compactMap { teamHost, teamOpponent in
                let warName = teamHost.team_tag! + " - " + teamOpponent.team_tag!
                let newWar = SDWar(newWar: war, name: warName)
                database.writeWar(war: newWar)
                finalList.append(newWar)
                if (finalList.count == warList.count) {
                   return
                }
            }
            .subscribe()
            .disposed(by: DisposeBag())
    }
}

@MainActor func withName(war: FBWar?, database: DatabaseRepository, onFinish: @escaping (MKWar?) -> Void) {
    guard let war = war else {
        onFinish(nil)
        return
    }
    Observable
        .zip(database.team(id: war.teamHost),database.team(id: war.teamOpponent))
        .compactMap { teamHost, teamOpponent in
            var current = MKWar(newWar: war)
            current.warName = teamHost.team_tag! + " - " + teamOpponent.team_tag!
            onFinish(current)
            return
        }
        .subscribe()
        .disposed(by: DisposeBag())
    
}

func positionToPoints(pos: Int?) -> Int {
   return switch(pos) {
    case 1:  15
    case 2:  12
    case 3:  10
    case 4:  9
    case 5:  8
    case 6:  7
    case 7:  6
    case 8:  5
    case 9:  4
    case 10:  3
    case 11:  2
    default:  1
    }
}

@MainActor func withTag(penalty: FBPenalty, database: DatabaseRepository, onFinish: @escaping (FBPenalty) -> Void) {
    database.team(id: penalty.teamId)
        .compactMap { team in
            let pena = FBPenalty(teamId: penalty.teamId, teamTag: team.team_tag ?? "", amount: penalty.amount)
            onFinish(pena)
            return
        }
        .subscribe()
        .disposed(by: DisposeBag())
}

func positionColor(position: Int) -> Int {
    return switch (position) {
    case 1: 0xD4AF37
    case 2: 0xC0C0C0
    case 3: 0xC49C48
    case 4: 0xF1B04C
    case 5: 0xEE9F27
    case 6: 0xEC9006
    case 7: 0xEC9006
    case 8: 0xE88504
    case 9: 0xE27602
    case 10: 0xE27602
    case 11: 0xDC6601
    case 12: 0xD24E01
    default: 0x000000
    }
}

func teamColor(color: Int?) -> Int {
    return switch (color) {
    case 1: 0xef5350
    case 2: 0xffa726
    case 3: 0xd4e157
    case 4: 0x66bb6a
    case 5: 0x26a69a
    case 6: 0x29b6f6
    case 7: 0x5c6bc0
    case 8: 0x7e57c2
    case 9: 0xec407a
    case 10: 0x888888
    case 11: 0xc62828
    case 12: 0xef6c00
    case 13: 0x9e9d24
    case 14: 0x2e7d32
    case 15: 0x00897b
    case 16: 0x0277bd
    case 17: 0x283593
    case 18: 0x4527a0
    case 19: 0xad1457
    case 20: 0x444444
    case 21: 0xd44a48
    case 22: 0xe69422
    case 23: 0xbdc74e
    case 24: 0x4a874c
    case 25: 0x208c81
    case 26: 0x25a5db
    case 27: 0x505ca6
    case 28: 0x6c4ca8
    case 29: 0xd13b6f
    case 30: 0x545454
    case 31: 0xab2424
    case 32: 0xd45f00
    case 33: 0x82801e
    case 34: 0x205723
    case 35: 0x006e61
    case 36: 0x0369a3
    case 37: 0x222d78
    case 38: 0x382185
    case 39: 0x91114b
    default: 0x000000
    }
}


