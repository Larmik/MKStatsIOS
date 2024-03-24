//
//  FirebaseRepository.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import FirebaseDatabaseInternal
import RxSwift

protocol FirebaseRepositoryProtocol {
    
    //SphlashScreen/Login
    func user(id: String) -> Observable<FBUser>
    func teams() -> Observable<[FBTeam]?>
    func allies() -> Observable<[String]?>
    func wars() -> Observable<[FBWar]>
    
    //Write and edit methods
    func writeUser(user: FBUser)
    func writeWar(war: FBWar)
    func writeCurrentWar(war: FBWar)
    //func writeAlly(ally: String)
    
    //Get firebase users, only on currentWar
    func users() -> Observable<[FBUser]>
    
    //Get/Listen current war by team Id, only on home and currentWar
   // func currentWar() -> Observable<MKWar?>
    func listenCurrentWar(onResponse: @escaping (MKWar?) -> Void)
    
    func deleteCurrentWar()
    
}

class FirebaseRepository: FirebaseRepositoryProtocol {
    
    func writeWar(war: FBWar) {
        self.ref.child("newWars").child("874").child(war.mid).setValue(
            [
                "mid": war.mid,
                "playerHostId": war.playerHostId,
                "teamHost": war.teamHost,
                "teamOpponent": war.teamOpponent,
                "createdDate": war.createdDate,
                "warTracks": war.warTracks.map { $0.toSnapshot() },
                "penalties":  war.penalties.map { $0.toSnapshot() },
                "isOfficial": war.isOfficial
            ]
        )
    }
    
    
    func deleteCurrentWar() {
        self.ref.child("currentWars").child("874").setValue(nil)
    }
    
    
    init(preferences: PreferencesRepository, database: DatabaseRepository) {
        self.preferences = preferences
        self.database = database
    }
    
    func writeCurrentWar(war: FBWar) {
        self.ref.child("currentWars").child("874").setValue(
            [
                "mid": war.mid,
                "playerHostId": war.playerHostId,
                "teamHost": war.teamHost,
                "teamOpponent": war.teamOpponent,
                "createdDate": war.createdDate,
                "warTracks": war.warTracks.map { $0.toSnapshot() },
                "penalties":  war.penalties.map { $0.toSnapshot() },
                "isOfficial": war.isOfficial
            ]
        )
    }
    
    
    func writeUser(user: FBUser) {
        self.ref.child("users").child(user.mid).setValue( [
        
            "mid": user.mid,
            "mkcId": user.mkcId!,
            "discordId": user.discordId!,
            "currentWar": user.currentWar!,
            "role": user.role!,
            "picture": user.picture!,
            "name":  user.name!
        ])
    }
    
    
    let preferences: PreferencesRepository
    let database: DatabaseRepository
    
  
    
    @MainActor func listenCurrentWar(onResponse: @escaping (MKWar?) -> Void) {
     
            self.ref.child("currentWars").child("874").observe(DataEventType.value) {  snapshot in
                let war = self.snaphotToWar(snapshot: snapshot)
                withName(war: war, database: self.database) { warWithName in
                    onResponse(warWithName)
                }
            }
          
    }
    
    
    private let ref = Database.database().reference()
    
    func allies() -> RxSwift.Observable<[String]?> {
        return Observable.create { [weak self] observer in
            var allyList = [String]()
            self?.ref.child("allies").child("874").getData {  error, snapshot in
                if (snapshot?.value != nil) {
                    guard let children = snapshot?.children else { return }
                    for child in children {
                        let childSnapshot = child as! DataSnapshot
                        let allyId = childSnapshot.value as! String
                        allyList.append(allyId)
                    }
                    
                } else {
                    observer.onNext([String]())
                    observer.onCompleted()
                }
                observer.onNext(allyList)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func user(id: String) -> RxSwift.Observable<FBUser> {
        return Observable.create { [weak self] observer in
            self?.ref.child("users").child(id).getData {  error, snapshot in
                if (snapshot?.value != nil) {
                    guard let userDic = snapshot?.value as? NSDictionary else { return }
                   let user = FBUser(
                    mid: userDic.object(forKey: "mid") as! String,
                    name: userDic.object(forKey: "name") as? String,
                    currentWar: userDic.object(forKey: "currentWar") as? String,
                    role: userDic.object(forKey: "role") as? Int,
                    picture: userDic.object(forKey: "picture") as? String,
                    mkcId: userDic.object(forKey: "mkcId") as? String,
                    discordId: userDic.object(forKey: "discordId") as? String
                   )
                    
                    observer.onNext(user)
                    observer.onCompleted()
                    
                } else {
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func users() -> RxSwift.Observable<[FBUser]> {
        return Observable.create { [weak self] observer in
            var userList = [FBUser]()
            self?.ref.child("users").getData {  error, snapshot in
                if (snapshot?.value != nil) {
                    guard let children = snapshot?.children else { return }
                    for child in children {
                        let childSnapshot = child as! DataSnapshot
                        let userDic = childSnapshot.value as! NSDictionary
                       let user = FBUser(
                        mid: userDic.object(forKey: "mid") as! String,
                        name: userDic.object(forKey: "name") as? String,
                        currentWar: userDic.object(forKey: "currentWar") as? String,
                        role: userDic.object(forKey: "role") as? Int,
                        picture: userDic.object(forKey: "picture") as? String,
                        mkcId: userDic.object(forKey: "mkcId") as? String,
                        discordId: userDic.object(forKey: "discordId") as? String
                       )
                        userList.append(user)
                    }
                    
                } else {
                    observer.onNext([FBUser]())
                    observer.onCompleted()
                }
                observer.onNext(userList)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func teams() -> RxSwift.Observable<[FBTeam]?> {
        return Observable.create { [weak self] observer in
            var teamList = [FBTeam]()
            self?.ref.child("teams").getData {  error, snapshot in
                if (snapshot?.value != nil) {
                    guard let children = snapshot?.children else { return }
                    for child in children {
                        let childSnapshot = child as! DataSnapshot
                        let teamDic = childSnapshot.value as! NSDictionary
                        let team = FBTeam(
                            mid: teamDic.object(forKey: "mid") as! String,
                            name: teamDic.object(forKey: "name") as? String,
                            shortName: teamDic.object(forKey: "shortName") as? String
                        )
                        teamList.append(team)
                    }
                    
                } else {
                    observer.onNext([FBTeam]())
                    observer.onCompleted()
                }
                observer.onNext(teamList)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @MainActor func wars() -> Observable<[FBWar]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            var warList = [FBWar]()
            self.ref.child("newWars").child("874").getData {  error, snapshot in
                if (snapshot?.value != nil) {
                    guard let children = snapshot?.children else { return }
                    for child in children {
                        guard let war = self.snaphotToWar(snapshot: child as! DataSnapshot) else { return }
                        warList.append(war)
                    }
                    observer.onNext(warList.sorted { old, new in old.mid > new.mid })
                    observer.onCompleted()
                } else {
                    observer.onNext([FBWar]())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    @MainActor private func snaphotToWar(snapshot: DataSnapshot) -> FBWar? {
        guard let warDic = snapshot.value as? NSDictionary else { return nil }
        var warTrackList = [FBWarTrack]()
        var penaltyList = [FBPenalty]()
        let warTracksDic = warDic.object(forKey: "warTracks") as? [NSDictionary] ??  [NSDictionary]()
        let penaltiesDic = warDic.object(forKey: "penalties") as? [NSDictionary] ??  [NSDictionary]()
        for track in warTracksDic {
            var positionList = [FBWarPosition]()
            var shockList = [FBShock]()
            let warPositionsDir = track.object(forKey: "warPositions") as? [NSDictionary] ??  [NSDictionary]()
            let shocksDir = track.object(forKey: "shocks") as? [NSDictionary] ??  [NSDictionary]()
            for position in warPositionsDir {
                let position = FBWarPosition(
                    mid: (position.object(forKey: "mid") as! String),
                    playerId: (position.object(forKey: "playerId") as! String),
                    position: (position.object(forKey: "position") as! Int)
                )
                positionList.append(position)
            }
            for shock in shocksDir {
                let shock = FBShock(playerId: (shock.object(forKey: "playerId") as! String),
                                  count: shock.object(forKey: "count") as! Int)
                shockList.append(shock)
            }
            
            let warTrack = FBWarTrack(
                mid: (track.object(forKey: "mid") as! String),
                trackIndex: (track.object(forKey: "trackIndex") as! Int),
                warPositions: positionList,
                shocks: shockList
            )
            warTrackList.append(warTrack)
        }
        for penalty in penaltiesDic {
            let penalty = FBPenalty(
                teamId: penalty.object(forKey: "teamId") as! String,
                amount: penalty.object(forKey: "amount") as! Int
            )
            withTag(penalty: penalty, database: database, onFinish: { newPena in
                penaltyList.append(newPena)

            })
        }
        return FBWar(
            mid: warDic.object(forKey: "mid") as! String,
            playerHostId: warDic.object(forKey: "playerHostId") as! String,
            teamHost: warDic.object(forKey: "teamHost") as! String,
            teamOpponent: warDic.object(forKey: "teamOpponent") as! String,
            createdDate: warDic.object(forKey: "createdDate") as! String,
            warTracks: warTrackList,
            penalties: penaltyList,
            isOfficial: warDic.object(forKey: "official") as? Bool ?? false
        )
    }

    
}



