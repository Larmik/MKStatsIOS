//
//  PlayersListViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/01/2024.
//

import Foundation
import RxSwift

@MainActor class PlayersListViewModel : ObservableObject, Identifiable {
    

    
    @Published private(set) var players: [UserSelector]?
    @Published private(set) var allies: [UserSelector]?
    @Published private(set) var warName: String?
    @Published private(set) var loadingState: String?
    @Published private(set) var enabled: Bool
    private let disposeBag: DisposeBag = DisposeBag()

    
    let database: DatabaseRepository
    let firebase: FirebaseRepository
    let preferences: PreferencesRepository
    let fetch: FetchUseCase
    let teamId: String
    var fbUsers: [FBUser]?
    let obs: Observable<[FBUser]>
    
    
    init(database: DatabaseRepository, preferences: PreferencesRepository, firebase: FirebaseRepository, fetch: FetchUseCase, teamId: String)
    {
        self.database = database
        self.preferences = preferences
        self.firebase = firebase
        self.fetch = fetch
        self.enabled = false
        self.teamId = teamId
        self.obs = firebase.users().asObservable()
        database.roster()
            .compactMap { roster in
                guard let roster = roster else { return }
                self.players = roster.filter { user in user.isAlly == 0 }.sorted(by: {first, second in first.name < second.name }).map { UserSelector(sdPlayer: $0, selected: false) }
                self.allies = roster.filter { user in user.isAlly == 1 }.sorted(by: {first, second in first.name < second.name }).map { UserSelector(sdPlayer: $0, selected: false) }
            }.subscribe()
            .disposed(by: self.disposeBag)
        
        database.team(id: teamId)
            .compactMap { team in
                self.warName = "\(preferences.mkcTeam?.team_tag ?? "") - \(team.team_tag!)"
            }.subscribe()
            .disposed(by: self.disposeBag)
        
        firebase.users()
            .compactMap {
                self.fbUsers = $0
            }.subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func selectUser(user: UserSelector) {
        var temp = [UserSelector]()
        self.players?.forEach { player in
            if (player.player.mkcId == user.player.mkcId) {
                temp.append(user)
            } else {
                temp.append(player)
            }
        }
        self.players = temp
        enableButtonIfNeeded()
    }
    
    func selectAlly(user: UserSelector) {
        var temp = [UserSelector]()
        self.allies?.forEach { player in
            if (player.player.mkcId == user.player.mkcId) {
                temp.append(user)
            } else {
                temp.append(player)
            }
        }
        self.allies = temp
        enableButtonIfNeeded()
    }
    
    func enableButtonIfNeeded() {
        let playersSize = players?.filter { $0.selected }.count ?? 0
        let alliesSize = allies?.filter { $0.selected }.count ?? 0
        let enabled = playersSize + alliesSize == 6
        self.enabled = enabled
    }
    
    @MainActor func createWar(official: Bool, onFinish: @escaping () -> Void) {
        self.loadingState = "Création de la war en cours..."
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "dd/MM/yyyy - HH'h'mm"
        let formattedDate = formatter.string(from: date)
        var timeMillis = String(date.timeIntervalSince1970)
        timeMillis.removeLast(3)
        
        let war = FBWar(
            mid: timeMillis.replacing(".", with: ""),
            playerHostId: String(preferences.mkcPlayer?.id ?? 0),
            teamHost: String(preferences.mkcTeam?.id ?? 0),
            teamOpponent: teamId,
            createdDate: formattedDate,
            warTracks: [],
            penalties: [],
            isOfficial: official
        )
        
        let selectedPlayers = self.players?.filter { $0.selected }.map { $0.player } ?? []
        let selectedAllies = self.allies?.filter { $0.selected }.map { $0.player } ?? []
        
        selectedPlayers.forEach { player in
            let new = MKCLightPlayer(lightPlayer: player, currentWar: war.mid)
            let fbUser = self.fbUsers?.first { $0.mkcId == String(player.mkcId) }
            let final = FBUser(player: new, mid: fbUser?.mid ?? "NOID", discordId: fbUser?.discordId ?? "NODISCORD", currentWar: war.mid)
            self.firebase.writeUser(user: final)
        }
        selectedAllies.forEach { player in
            let new = MKCLightPlayer(lightPlayer: player, currentWar: war.mid)
            let fbUser = self.fbUsers?.first { $0.mkcId == String(player.mkcId) }
            let final = FBUser(player: new, mid: fbUser?.mid ?? "NOID", discordId: fbUser?.discordId ?? "NODISCORD", currentWar: war.mid)
            self.firebase.writeUser(user: final)
        }
        self.preferences.currentWar = MKWar(newWar: war)
        self.firebase.writeCurrentWar(war: war)
        self.fetch.fetchPlayers(forceUpdate: true)
            .delay(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onCompleted: {
                self.loadingState = nil
                onFinish()
            })
            .disposed(by: self.disposeBag)
    }
       

}

struct UserSelector: Identifiable {
    var id = UUID()
    
    let player: MKCLightPlayer
    let selected: Bool
    
    init(sdPlayer: SDPlayer, selected: Bool) {
        self.player = MKCLightPlayer(mkPlayer: sdPlayer)
        self.selected = selected
    }
    
    init(mkcPlayer: MKCLightPlayer, selected: Bool) {
        self.player = mkcPlayer
        self.selected = selected
    }
}
