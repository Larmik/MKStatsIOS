//
//  WarTrackResultViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/02/2024.
//

import Foundation
import RxSwift

@MainActor class WarTrackResultViewModel : ObservableObject, Identifiable {
    
    private let preferences: PreferencesRepository
    private let database: DatabaseRepository
    private let firebase: FirebaseRepository
    private let trackIndex: Int?
    
    @Published private(set) var currentMap: Maps?
    @Published private(set) var track: MKWarTrack?
    @Published private(set) var trackNumber: String?
    @Published private(set) var warPos: [MKPlayerWarPosition]?
    @Published private(set) var playerLabel: String?
    @Published private(set) var war: MKWar?
    @Published private(set) var shocks: [MKShock]?
    
    private var positions = [MKWarPosition]()
    private var users = [MKCLightPlayer]()
    private var finalList = [MKShock]()
    private var roster = [SDPlayer]()
    private var shocksMap: Dictionary<String, Int> = Dictionary()

    private let disposeBag = DisposeBag()
    private var currentTrack: MKWarTrack? = nil
    
    init(preferences: PreferencesRepository, database: DatabaseRepository, firebase: FirebaseRepository, trackIndex: Int?) {
        
        self.preferences = preferences
        self.firebase = firebase
        self.database = database
        self.trackIndex = trackIndex
        
  
        database.roster()
            .compactMap { roster in
                guard let roster = roster else { return }
                self.currentTrack = switch trackIndex  {
                     case nil: preferences.currentWarTrack!
                     default: preferences.currentWar?.warTracks[trackIndex!]
                 }
                let trackIndexInMapList = self.currentTrack?.trackIndex
                
                self.trackNumber = switch (trackIndex) {
                case 12: "Dernière course"
                case 11: "11ème course"
                case 10: "10ème course"
                case 9: "9ème course"
                case 8: "8ème course"
                case 7: "7ème course"
                case 6: "6ème course"
                case 5: "5ème course"
                case 4: "4ème course"
                case 3: "3ème course"
                case 2: "2ème course"
                default: "1ère course"
                }
                self.roster = roster
                self.users.append(contentsOf: roster.map { MKCLightPlayer(mkPlayer: $0)})
                self.war = preferences.currentWar
                self.currentMap = Maps.allCases[self.currentTrack?.trackIndex ?? trackIndex ?? 0]
                self.initShockList()
                if (self.positions.count == 6) {
                    self.track = self.currentTrack
                }
            }
            .subscribe()
            .disposed(by: self.disposeBag)
    }


      private func initShockList() {
          finalList.removeAll()
          positions.removeAll()
          var tracks = [MKWarTrack]()
          var newTrack = currentTrack

          currentTrack?.warPositions
              .sorted(by: {first, second in first.position ?? 0 < second.position ?? 0 })
              .forEach { pos in
                  let shocksForPlayer = shocksMap[pos.playerId ?? ""] ?? currentTrack?.shocks.first(where: {$0.playerId == pos.playerId})?.count ?? 0
                  positions.append(pos)
                  shocksMap[pos.playerId ?? ""] = shocksForPlayer
              }
          shocksMap.filter({ map in map.value > 0}).forEach { self.finalList.append(MKShock(playerId: $0.key, count: $0.value)) }
          tracks.append(contentsOf: preferences.currentWar?.warTracks.filter { tr in tr.mid != currentTrack?.mid } ?? [])
          newTrack?.shocks = finalList
          if (newTrack != nil) {
              switch trackIndex {
              case nil: tracks.append(newTrack!)
              default: tracks.insert(newTrack!, at: trackIndex!)

              }
          }
          preferences.currentWar?.warTracks = tracks
          self.shocks = finalList
          self.warPos = positions.map { pos in
              MKPlayerWarPosition(position: pos, mkcPlayer: roster.first { $0.mkcId == pos.playerId })
          }
      }
    
    func onAddShock(playerId: String) {
        let value = shocksMap[playerId] ?? 0
        shocksMap.updateValue(value + 1, forKey: playerId)
        initShockList()
    }
    
    func onRemoveShock(playerId: String) {
        guard let value = shocksMap[playerId] else { return }
        if (value > 0) {
            shocksMap.updateValue(value - 1, forKey: playerId)
            initShockList()
        }
    }
    
    func onValid() {
        guard let currentWar = preferences.currentWar else { return }
        firebase.writeWar(war: FBWar(war: currentWar))
    }
    
}
