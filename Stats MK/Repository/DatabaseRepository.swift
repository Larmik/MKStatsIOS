//
//  DatabaseRepository.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import SwiftData
import RxSwift

protocol DatabaseRepositoryProtocol {
    //get methods
    func wars() -> Observable<[SDWar]>
    func teams() -> Observable<[SDTeam]>
    func roster() -> Observable<[SDPlayer]?>
    func user(id: String) -> Observable<SDPlayer>
    func war(id: String) -> Observable<SDWar>
    func team(id: String) -> Observable<SDTeam>

    //write methods
    func writeRoster(rosterList: [SDPlayer])
    func writeTeams(teamList: [SDTeam])
    func writeUser(user: SDPlayer)
    func writeWar(war: SDWar)
    
    //clear methods
    func clearRoster()
    func clearWars()
    
}

class DatabaseRepository: DatabaseRepositoryProtocol {
    
    @MainActor func clearWars() {
        let context = self.container.mainContext
        try! context.delete(model: SDWar.self)
        try! context.delete(model: SDWarTrack.self)
        try! context.delete(model: SDWarPosition.self)
        try! context.delete(model: SDPenalty.self)
        try! context.delete(model: SDShock.self)
    }
    
    
    @MainActor func clearRoster() {
        let context = self.container.mainContext
        try! context.delete(model: SDPlayer.self)
    }
     
    let container: ModelContainer
    
    init() {
        do {
            print("init container")
            self.container = try ModelContainer(for: SDWar.self, SDTeam.self, SDPlayer.self, SDWarTrack.self, SDWarPosition.self, SDPenalty.self, SDShock.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
    
    @MainActor func team(id: String) -> RxSwift.Observable<SDTeam> {
        return Observable.create { [weak self] observer in
            guard let context = self?.container.mainContext else { return Disposables.create()}
            var descriptor = FetchDescriptor<SDTeam>(predicate: #Predicate { war in war.id == id })
            descriptor.includePendingChanges = true
            do {
                guard let results = try context.fetch(descriptor).first else { return Disposables.create() }
                observer.onNext(results)
                observer.onCompleted()
            } catch {
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @MainActor func writeUser(user: SDPlayer) {
        let context = self.container.mainContext
        print("insert user in db: \(user.name)")
        context.insert(user)
    }
    
    @MainActor func writeWar(war: SDWar) {
        let context = self.container.mainContext
        print("insert war in db: \(war.warName!)")            
        context.insert(war)
    }
    
    @MainActor func war(id: String) -> RxSwift.Observable<SDWar> {
        return Observable.create { [weak self] observer in
            guard let context = self?.container.mainContext else { return Disposables.create()}
            var descriptor = FetchDescriptor<SDWar>(predicate: #Predicate { war in war.mid == id })
            descriptor.includePendingChanges = true
            do {
                guard let results = try context.fetch(descriptor).first else { return Disposables.create() }
                observer.onNext(results)
                observer.onCompleted()
            } catch {
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @MainActor func user(id: String) -> RxSwift.Observable<SDPlayer> {
        return Observable.create { [weak self] observer in
            guard let context = self?.container.mainContext else { return Disposables.create()}
            var descriptor = FetchDescriptor<SDPlayer>(predicate: #Predicate { user in user.mid == id })
            descriptor.includePendingChanges = true
            do {
                guard let results = try context.fetch(descriptor).first else { return Disposables.create() }
                observer.onNext(results)
                observer.onCompleted()
            } catch {
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @MainActor func roster() -> RxSwift.Observable<[SDPlayer]?> {
        return Observable.create { [weak self] observer in
            guard let context = self?.container.mainContext else { return Disposables.create()}
            var descriptor = FetchDescriptor<SDPlayer>()
            descriptor.includePendingChanges = true
            do {
                let results = try context.fetch(descriptor)
                observer.onNext(results)
                observer.onCompleted()
            } catch {
                observer.onNext([])
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @MainActor func writeRoster(rosterList: [SDPlayer]) {
        let context = self.container.mainContext
        for player in rosterList {
            print("insert player in db: \(player.name)")
            context.insert(player)
        }
    }

    @MainActor func teams() -> Observable<[SDTeam]> {
        return Observable.create { [weak self] observer in
            guard let context = self?.container.mainContext else { return Disposables.create()}
            var descriptor = FetchDescriptor<SDTeam>()
            descriptor.includePendingChanges = true
            do {
                let results = try context.fetch(descriptor)
                observer.onNext(results)
                observer.onCompleted()
            } catch {
                observer.onNext([SDTeam]())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @MainActor func wars() -> Observable<[SDWar]> {
        return Observable.create { [weak self] observer in
            guard let context = self?.container.mainContext else { return Disposables.create() }
            var descriptor = FetchDescriptor<SDWar>()
            descriptor.includePendingChanges = true
            do {
                let results = try context.fetch(descriptor)
                observer.onNext(results)
                observer.onCompleted()
            } catch {
                observer.onNext([SDWar]())
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    @MainActor func writeTeams(teamList: [SDTeam])  {
        let context = self.container.mainContext
        for team in teamList {
            print("insert team in db: \(team.team_name!)")
            context.insert(team)
        }
    }
    
}
