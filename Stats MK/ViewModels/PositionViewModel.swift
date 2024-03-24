//
//  PositionViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 28/01/2024.
//

import Foundation
import RxSwift

@MainActor class PositionViewModel : ObservableObject, Identifiable {
    
    @Published private(set) var map: Maps?
    @Published private(set) var selectedPositions = [Int]()
    @Published private(set) var playerLabel: String?
    @Published private(set) var war: MKWar?
    
    private let preferences: PreferencesRepository
    private let firebase: FirebaseRepository
    private let goToResult: (Int) -> Void
    private let warTrackIndex: Int?

    private let disposeBag = DisposeBag()
    var positions = [FBWarPosition]()
    var currentPlayers = [MKCLightPlayer]()
    var currentPlayer: MKCLightPlayer?
    var currentPlayerIndex = 0
    
    init(preferences: PreferencesRepository, database: DatabaseRepository, firebase: FirebaseRepository, trackIndex: Int, warTrackIndex: Int?, goToResult: @escaping (Int) -> Void) {
        self.map = Maps.allCases[trackIndex]
        self.war = preferences.currentWar
        self.goToResult = goToResult
        self.preferences = preferences
        self.firebase = firebase
        self.warTrackIndex = warTrackIndex
        guard let current = preferences.currentWar else { return }
        database.roster()
            .compactMap { roster in
                guard let roster = roster else { return }
                self.currentPlayers.append(contentsOf: roster.filter { user in
                    user.currentWar == current.mid
                }.sorted(by: { first, second in first.name < second.name }).map{ MKCLightPlayer(mkPlayer: $0) })
                self.currentPlayer = self.currentPlayers[self.currentPlayerIndex]
                self.playerLabel = self.currentPlayer?.name
            }
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func onPositionClick(position: Int, onTrackEdited: @escaping () -> Void) {
        var timeMillis = String(Date().timeIntervalSince1970)
        timeMillis.removeLast(3)
        let position = FBWarPosition(mid: timeMillis.replacing(".", with: ""), playerId: String(self.currentPlayer?.mkcId ?? 0), position: position)
        self.positions.append(position)
        self.selectedPositions = self.positions.map { $0.position ?? 0 }
        if (self.positions.count >= self.currentPlayers.count) {
            guard let warTrack = switch warTrackIndex {
            case nil: preferences.currentWarTrack
            default: preferences.currentWar?.warTracks[warTrackIndex!]
            } else { return }
                var tracks = [MKWarTrack]()
                let newTrack = MKWarTrack(mid: warTrack.mid, index: warTrack.trackIndex, positions: self.positions.map { MKWarPosition(fbPosition: $0)})
                switch warTrackIndex {
                case nil: do {
                    tracks.append(contentsOf: self.preferences.currentWar?.warTracks.filter({ tr in tr.mid != warTrack.mid }) ?? [])
                    tracks.append(warTrack)
                    preferences.currentWarTrack = newTrack
                    goToResult(warTrack.trackIndex)
                }
                default: do {
                    tracks.append(contentsOf: self.preferences.currentWar?.warTracks.filter({ tr in tr.mid != warTrack.mid }) ?? [])
                    tracks.insert(newTrack, at: self.warTrackIndex!)
                    var newWar = preferences.currentWar
                    newWar?.warTracks = tracks
                    guard let war = newWar else { return }
                    firebase.writeCurrentWar(war: FBWar(war: war))
                    preferences.currentWar = war
                    self.positions.removeAll()
                    onTrackEdited()
                }
                }
            
        } else {
            self.currentPlayerIndex += 1
            self.currentPlayer = self.currentPlayers[self.currentPlayerIndex]
            self.playerLabel = self.currentPlayer?.name
        }
    }
    
}
