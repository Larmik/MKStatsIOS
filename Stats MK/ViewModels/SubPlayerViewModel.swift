//
//  SubPlayerViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/02/2024.
//

import Foundation
import RxSwift


@MainActor class SubPlayerViewModel : ObservableObject, Identifiable {
    
    private let firebase: FirebaseRepository
    private let database: DatabaseRepository
    private let preferences: PreferencesRepository
    private let disposeBag: DisposeBag = DisposeBag()

    @Published private(set) var players = [UserSelector]()
    @Published private(set) var allies = [UserSelector]()
    @Published private(set) var title = "Joueur sortant"
    @Published private(set) var playerSelected: MKCLightPlayer? = nil

    private var playersList = [UserSelector]()
    private var allyList = [UserSelector]()
    private var currentPlayersList = [UserSelector]()
    private var fbUsers = [FBUser]()

    var oldPlayer: MKCLightPlayer? = nil
    var newPlayer: MKCLightPlayer? = nil

    init(firebase: FirebaseRepository, database: DatabaseRepository, preferences: PreferencesRepository) {
        self.firebase = firebase
        self.database = database
        self.preferences = preferences
        
        database.roster()
            .do(onNext: { it in
                self.playersList.removeAll()
                self.allyList.removeAll()
                self.currentPlayersList.removeAll()
                self.playersList.append(contentsOf: it?.filter { user in user.currentWar == "-1" && user.isAlly == 0 }.map { user in  UserSelector(sdPlayer: user, selected: false) } ?? [])
                self.allyList.append(contentsOf: it?.filter { user in user.currentWar == "-1" &&  user.isAlly == 1 }.map { user in UserSelector(sdPlayer: user, selected: false) } ?? [])
                self.currentPlayersList.append(contentsOf: it?.filter { user in user.currentWar == preferences.currentWar?.mid }.map { user in UserSelector(sdPlayer: user, selected: false) } ?? [])
                self.players = self.currentPlayersList
                self.title = "Joueur sortant"
            })
            .flatMapLatest { _ -> Observable<[FBUser]> in
                return firebase.users()
            }
            .compactMap { users in
                self.fbUsers.removeAll()
                self.fbUsers.append(contentsOf: users)
            }
            .subscribe()
            .disposed(by: self.disposeBag)
        
    }
    
    func onOldPlayerSelect(user : MKCLightPlayer) {
        oldPlayer = user
        self.players = playersList
        self.allies = allyList
        self.title = "Joueur entrant"
        self.playerSelected = user
    }
    
    func onBack() {
        self.players = currentPlayersList
        self.allies = []
        self.playerSelected = nil
        self.title = "Joueur sortant"
    }
    
    func onNewPlayerSelect(user: MKCLightPlayer) {
         newPlayer = user
         var playerListWithSelected = [UserSelector]()
         var allyListWithSelected = [UserSelector]()
         playersList.forEach {
             switch ($0.player.mkcId == user.mkcId) {
             case true: playerListWithSelected.append(UserSelector(mkcPlayer: $0.player, selected: true))
             default: playerListWithSelected.append($0)
             }
         }
         allyList.forEach {
             switch ($0.player.mkcId == user.mkcId) {
             case true: allyListWithSelected.append(UserSelector(mkcPlayer: $0.player, selected: true))
             default: allyListWithSelected.append($0)
             }
         }
         players = playerListWithSelected
         allies = allyListWithSelected
     }
    
    func onSubClick(onFinish: @escaping () -> Void) {
        oldPlayer?.currentWar = "-1"
        newPlayer?.currentWar = preferences.currentWar?.mid ?? "-1"
        let fbOld = fbUsers.first(where: { user in user.mkcId == String(oldPlayer?.mkcId ?? 0) })
        let finalOld = FBUser(player: oldPlayer, mid: fbOld?.mid ?? "", discordId: fbOld?.discordId, currentWar: "-1")
        let oldIsAlly = currentPlayersList.first(where: { user in String(user.player.mkcId) == finalOld.mkcId})?.player.isAlly

        let fbNew = fbUsers.first(where: { user in user.mkcId == String(newPlayer?.mkcId ?? 0) })
        let finalNew = FBUser(player: newPlayer, mid: fbNew?.mid ?? "", discordId: fbNew?.discordId, currentWar: preferences.currentWar?.mid ?? "-1")
        let newIsAlly = switch (true) {
        case self.allyList.map { String($0.player.mkcId) }.contains(where: { $0 == finalNew.mkcId}): 1
        default: 0
        }
        firebase.writeUser(user: finalOld)
        database.writeUser(user: SDPlayer(user: finalOld, isAlly: oldIsAlly ?? 0))
        firebase.writeUser(user: finalNew)
        database.writeUser(user: SDPlayer(user: finalNew, isAlly: newIsAlly))
        oldPlayer = nil
        newPlayer = nil
        playersList.removeAll()
        allyList.removeAll()
        currentPlayersList.removeAll()
        fbUsers.removeAll()
        playerSelected = nil
        onFinish()
   }
    
}

