//
//  CurrentWarViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import Foundation
import RxSwift

@MainActor class CurrentWarViewModel : ObservableObject, Identifiable {
    
    
    @Published private(set) var war: MKWar?
    @Published private(set) var buttonsVisible: Bool = false
    @Published private(set) var players: [CurrentPlayer] = [CurrentPlayer]()
    @Published private(set) var loadingState: String?


    private let disposeBag: DisposeBag = DisposeBag()
    
    private let database: DatabaseRepository
    private let firebase: FirebaseRepository
    private let fetch: FetchUseCase
    
    init(
        firebaseRepository: FirebaseRepository,
        databaseRepository: DatabaseRepository,
        authenticationRepository: AuthenticationRepository,
        preferencesrepository: PreferencesRepository,
        fetchUseCase: FetchUseCase,
        onBack: @escaping () -> Void
    ) {
        self.database = databaseRepository
        self.firebase = firebaseRepository
        self.fetch = fetchUseCase
        firebaseRepository.listenCurrentWar { war in
            if (war == nil) {
                onBack()
            }
            preferencesrepository.currentWar = war
            self.buttonsVisible = preferencesrepository.role >= 2 && war?.playerHostId == String(preferencesrepository.mkcPlayer?.id ?? 0)
            self.war = war
            self.bindPlayers(database: databaseRepository)
        }
    }
    
    func initFirstLaunch() {
        if (self.war != nil && (self.war?.warTracks.isEmpty) ?? true) {
            bindPlayers(database: self.database)
        }
    }
    
    func cancelWar(onFinish: @escaping () -> Void) {
        database.roster()
            .do(onNext: { [weak self] roster in
                guard let roster = roster else { return }
                roster.filter { $0.currentWar != "-1" }
                    .forEach { player in
                        let final = FBUser(sdPlayer: player)
                        self?.firebase.writeUser(user: final)
                        self?.database.writeUser(user: SDPlayer(user: final, isAlly: player.isAlly))
                    
                    }
                self?.firebase.deleteCurrentWar()
                onFinish()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
                     
    }
    
    func validateWar(onFinish: @escaping () -> Void) {
        guard let war = self.war else { return }
        let fbWar = FBWar(war: war)
        firebase.writeWar(war: fbWar)
        fetch.fetchWars()
            .do(onNext: {
                self.cancelWar(onFinish: onFinish)

            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func bindPlayers(database: DatabaseRepository) {
        database.roster()
            .compactMap {  roster in
                var positions = [(SDPlayer?, Int)]()
                var shocks = [MKShock]()
                self.war?.warTracks.forEach { track in
                    var trackPositions = [MKPlayerWarPosition]()
                    track.warPositions.forEach { position in
                        trackPositions.append(
                            MKPlayerWarPosition(position: position, mkcPlayer: roster?.first { $0.mkcId == position.playerId })
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
                if (finalList.isEmpty) {
                    self.players = roster?.filter { $0.currentWar == self.war?.mid }.map{ CurrentPlayer(player: MKCLightPlayer(mkPlayer: $0), score: 0, old: false, new: false, shockCount: 0)} ?? []
                } else {
                    self.players = finalList
                }
            }.subscribe().disposed(by: self.disposeBag)
    }
    
}
