//
//  FetchUseCase.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation
import RxSwift

protocol FetchUseCaseProtocol {
    func fetchPlayer(id: String) -> Observable<MKCFullTeam?>
    func fetchTeams() -> Observable<Void>
    func fetchPlayers(forceUpdate: Bool) -> Observable<Void>
    func fetchWars() -> Observable<Void>
}

class FetchUseCase: FetchUseCaseProtocol {
    
    private let mkCentralRepository =  MKCentralRepository()
    private let firebaseRepository: FirebaseRepository
    private let preferencesRepository: PreferencesRepository
    private let databaseRepository: DatabaseRepository
    private let authenticationRepository: AuthenticationRepository
    
    init(firebaseRepository: FirebaseRepository, preferencesRepository: PreferencesRepository, databaseRepository: DatabaseRepository, authenticationRepository: AuthenticationRepository) {
        self.firebaseRepository = firebaseRepository
        self.preferencesRepository = preferencesRepository
        self.databaseRepository = databaseRepository
        self.authenticationRepository = authenticationRepository
    }
    
    private var allies = [String]()
    private var users = [FBUser]()
    private let instantObservables = InstantObservables<Void>()
    
    func fetchPlayer(id: String) -> Observable<MKCFullTeam?> {
        return firebaseRepository.user(id: id)
            .do(onNext: {
                print("fetching user...")
                self.preferencesRepository.role = $0.role ?? 0
            })
            .flatMapLatest{ [weak self] user -> Observable<MKCFullPlayer?> in
                guard let self = self else { return .just(nil) }
                return self.mkCentralRepository.player(id: user.mkcId ?? "")
            }
            .do(onNext: {
                self.preferencesRepository.mkcPlayer = $0
            })
            .flatMapLatest { [weak self] player -> Observable<MKCFullTeam?> in
                guard let self = self else { return .just(nil) }
                let teamId = player?.current_teams.first?.team_id ?? 0
                return mkCentralRepository.team(id: String(teamId))
                
            }
            .do(onNext: { team in
                self.preferencesRepository.mkcTeam = team
                self.preferencesRepository.rosterList = team?.rosters
            })
    }
    
    @MainActor func fetchTeams() -> Observable<Void> {
        return Observable
            .zip(mkCentralRepository.teams(), mkCentralRepository.historicalTeams(), databaseRepository.teams(), firebaseRepository.teams())
            .compactMap { [weak self] active, historical, local, firebase in
                guard let self = self else { return }
                let localCount = local.count
                let remoteCount = (active?.count ?? 0) + (historical?.count ?? 0) + (firebase?.count ?? 0)
                print("fetching teams... remote count: \(remoteCount) local count: \(localCount)")
                if (remoteCount != localCount) {
                    self.databaseRepository.writeTeams(teamList: active?.map { SDTeam(mkcTeam: $0) } ?? [])
                    self.databaseRepository.writeTeams(teamList: historical?.map { SDTeam(mkcTeam: $0) } ?? [])
                    self.databaseRepository.writeTeams(teamList: firebase?.map { SDTeam(team: $0) } ?? [])
                }
                return
            }
    }
    
    @MainActor func fetchPlayers(forceUpdate: Bool = false) -> Observable<Void> {
        return Observable
            .zip(firebaseRepository.users(), firebaseRepository.allies(), databaseRepository.roster())
            .compactMap { [weak self] users, allies, players in
                guard let self = self else { return }
                self.users.removeAll()
                self.allies.removeAll()
                self.users.append(contentsOf: users)
                self.allies.append(contentsOf: allies ?? [])
                let list = preferencesRepository.rosterList ?? []
                let localCount = players?.count ?? 0
                let remoteCount = list.count + (allies?.count ?? 0)
                print("fetching players... local count: \(localCount), remote count: \(remoteCount)")
                if (localCount != remoteCount || forceUpdate) {
                    var missingPlayers = [MKCLightPlayer]()
                    var missingAllies = [String]()
                    list.forEach { p in
                        if (!players!.filter({ ply in ply.isAlly == 0}).map{ $0.mkcId }.contains(String(p.mkcId)) || forceUpdate) {
                            print("missing player if exists \(p.name)")
                            missingPlayers.append(p)
                        }
                    }
                    allies?.forEach { a in
                        if (!players!.filter({ ply in ply.isAlly != 0}).map{ $0.mkcId }.contains(a) || forceUpdate) {
                            print("missing ally if exists \(a)")
                            missingAllies.append(a)
                        }
                    }
                    setPlayers(list: missingPlayers, allyList: missingAllies, onFinish: {
                        self.databaseRepository.writeRoster(rosterList: $0)
                        return
                    })
                }
            }
    }
    
    @MainActor func fetchWars() -> Observable<Void> {
        return Observable
            .zip(firebaseRepository.wars(), databaseRepository.wars())
            .compactMap {
                [weak self] remoteDb, localDb  in
                guard let self = self else { return }
                let finalLocalDb = localDb.filter { $0.teamHost == String(self.preferencesRepository.mkcTeam?.id ?? 0)}
                print("fetching wars... remote count: \(remoteDb.count) local count: \(finalLocalDb.count)")
                if (finalLocalDb.count != remoteDb.count) {
                    withName(warList: remoteDb.filter { remote in !localDb.map { $0.mid }.contains(remote.mid) }, database: self.databaseRepository) {
                        return
                    }
                }
            }
    }
    
    private func setPlayers(list: [MKCLightPlayer], allyList: [String], onFinish: @escaping ([SDPlayer]) -> Void) {
        var finalList = [SDPlayer]()
        list.forEach { [weak self] player in
            guard let self = self else { return }
            instantObservables.enqueue(observable:
                self.mkCentralRepository.player(id: "\(player.mkcId)")
                    .compactMap { mkcPlayer  in
                        let fbUser = self.users.first { item in item.mkcId == "\(player.mkcId)" }
                        finalList.append(SDPlayer(
                            player: mkcPlayer,
                            mid: fbUser?.mid ?? "",
                            role: fbUser?.role ?? 0,
                            isAlly: player.isAlly,
                            isLeader: player.isLeader,
                            currentWar: fbUser?.currentWar ?? "-1",
                            discordId: fbUser?.discordId ?? ""
                        )
                         )
                        if (finalList.count == list.count + self.allies.count) {
                            onFinish(finalList)
                        }
                    }
            )
        }
        
        allyList.forEach { [weak self] ally in
            guard let self = self else { return }
            instantObservables.enqueue(observable:
                self.mkCentralRepository.player(id: ally)
                    .compactMap { mkcPlayer in
                        let fbUser = self.users.first { item in item.mkcId == ally }
                        if (mkcPlayer != nil) {
                            finalList.append(SDPlayer(
                                player: mkcPlayer,
                                mid: fbUser?.mid ?? "",
                                role: fbUser?.role ?? 0,
                                isAlly: 1,
                                isLeader: 0,
                                currentWar: fbUser?.currentWar ?? "-1",
                                discordId: fbUser?.discordId ?? ""
                            )
                            )
                        }
                        else if (fbUser != nil) {
                            finalList.append(SDPlayer(user: fbUser!, isAlly: 1))
                        }
                        if (finalList.count == list.count + allyList.count) {
                            onFinish(finalList)
                        }
                    }
            )
        }
        
        instantObservables
            .waitForAllObservablesToBeFinished()
            .subscribe()
            .disposed(by: DisposeBag())
    }
    
}
