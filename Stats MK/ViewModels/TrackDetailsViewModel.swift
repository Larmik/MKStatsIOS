//
//  TrackDetailsViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 24/01/2024.
//

import Foundation
import RxSwift

@MainActor class TrackDetailsViewModel : ObservableObject, Identifiable {
    
    private let preferences: PreferencesRepository
    private let database: DatabaseRepository
    private let trackId: String
    private var roster = [SDPlayer]()
    
    @Published private(set) var war: MKWar?
    @Published private(set) var track: MKWarTrack?
    @Published private(set) var map: Maps?
    @Published private(set) var players: [MKPlayerWarPosition] = [MKPlayerWarPosition]()
    @Published private(set) var canEdit: Bool
    private let disposeBag: DisposeBag = DisposeBag()


    init(databaseRepository: DatabaseRepository, preferencesRepository: PreferencesRepository, warId: String, trackId: String, trackIndex: Int?) {
        self.preferences = preferencesRepository
        self.database = databaseRepository
        self.trackId = trackId
        let current = trackIndex != nil
        self.canEdit = current
        if (!current) {
            Observable.zip(databaseRepository.roster(), databaseRepository.war(id: warId))
                .compactMap { roster, war in
                    guard let roster = roster else { return Disposables.create() }
                    self.roster = roster
                    let mkWar = MKWar(sdWar: war)
                    let mkTrack = mkWar.warTracks.first { track in track.mid == trackId }
                    var positions = [MKPlayerWarPosition]()
                    mkTrack?.warPositions.forEach { pos in
                        positions.append(MKPlayerWarPosition(position: pos, mkcPlayer: roster.first { it in it.mkcId == pos.playerId }))
                    }
                    self.war = mkWar
                    self.track = mkTrack
                    self.map = Maps.allCases.first(where: { map in map.trackIndex == mkTrack?.trackIndex})
                    self.players = positions.sorted { first, second in first.position.position! < second.position.position!}
                    return Disposables.create()
                }
                .subscribe()
                .disposed(by: self.disposeBag)
        } else {
            setPositions()
        }
    }
    
    func setTrack(map: Maps) {
        self.map = map
    }
    
    func setPositions() {
        database.roster()
            .compactMap { roster in
                guard let roster = roster else { return Disposables.create() }
                self.roster = roster
                let mkWar = self.preferences.currentWar
                let mkTrack = mkWar?.warTracks.first { track in track.mid == self.trackId }
                var positions = [MKPlayerWarPosition]()
                mkTrack?.warPositions.forEach { pos in
                    positions.append(MKPlayerWarPosition(position: pos, mkcPlayer: roster.first { it in it.mkcId == pos.playerId }))
                }
                self.war = mkWar
                self.track = mkTrack
                self.players = positions.sorted { first, second in first.position.position! < second.position.position!}
                return Disposables.create()
            }
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
}
