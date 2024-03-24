//
//  WarDetailsViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import Foundation
import RxSwift

@MainActor class WarDetailsViewModel : ObservableObject, Identifiable {
    
    
    @Published private(set) var war: MKWar?
    @Published private(set) var players: [CurrentPlayer] = [CurrentPlayer]()
    private let disposeBag: DisposeBag = DisposeBag()

    

    init(databaseRepository: DatabaseRepository, warId: String) {
        databaseRepository.war(id: warId)
            .compactMap {  war in
                let mkWar = MKWar(sdWar: war)
                self.war = mkWar
            }
            .concatMap { _ -> Observable<[SDPlayer]?> in
                return databaseRepository.roster()
                
            }
            .compactMap { players in
                guard let players = players else { return }
                var positions = [(SDPlayer?, Int)]()
                var shocks = [MKShock]()
                self.war?.warTracks.forEach { track in
                    var trackPositions = [MKPlayerWarPosition]()
                    track.warPositions.forEach { position in
                        trackPositions.append(
                            MKPlayerWarPosition(position: position, mkcPlayer: players.first { $0.mkcId == position.playerId })
                        )
                    }
                    Dictionary.init(grouping: trackPositions, by: { $0.mkcPlayer }).forEach { key, value in
                        positions.append((key, value.map { positionToPoints(pos: $0.position.position)}.reduce(0, +)))
                    }
                    shocks.append(contentsOf: track.shocks)
                }
                let temp = Dictionary.init(grouping: positions, by: { $0.0 })
                    .map { ($0.key, $0.value.map { $0.1 }.reduce(0, +))}.sorted(by: {first, second in first.1 > second.1 })
                var finalList = [CurrentPlayer]()
                temp.forEach { pair in
                    let shockCount = shocks.filter { shock in shock.playerId == pair.0?.mkcId }.map { $0.count }.reduce(0, +)
                    let finalPlayer = MKCLightPlayer(mkPlayer: pair.0)
                    finalList.append(CurrentPlayer(player: finalPlayer, score: pair.1, old: nil, new: nil, shockCount: shockCount))
                }
                self.players = finalList
            }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        
    }
   
    
    
}
