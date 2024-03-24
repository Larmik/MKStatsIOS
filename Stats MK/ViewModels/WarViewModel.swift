//
//  WarViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import RxSwift
import RxCocoa

@MainActor class WarViewModel : ObservableObject, Identifiable {
    
    
    private let database: DatabaseRepository
    private let preferences: PreferencesRepository
    private let disposeBag: DisposeBag = DisposeBag()

    
    @Published private(set) var warList = [MKWar]()
    @Published private(set) var currentWar: MKWar?
    @Published private(set) var team: MKCFullTeam?
    @Published private(set) var buttonsVisible: Bool
    @Published private(set) var loadingState: String?
  
    
    init(preferences: PreferencesRepository, database: DatabaseRepository, firebase: FirebaseRepository, fetch: FetchUseCase) {
        self.team = preferences.mkcTeam
        self.database = database
        self.preferences = preferences
        self.buttonsVisible = preferences.role >= 2
        if (preferences.mkcTeam != nil) {
            firebase.listenCurrentWar() { war in
                if (war == nil) {
                    preferences.currentWar = nil
                    self.currentWar = nil
                } else if (war?.warTracks.isEmpty ?? true) {
                    self.loadingState = "Récupération de la war en cours..."
                    preferences.currentWar = war
                    self.currentWar = war
                    fetch.fetchPlayers()
                        .delay(.seconds(3), scheduler: MainScheduler.instance)
                        .subscribe(onCompleted: {
                            self.loadingState = nil
                            preferences.currentWar = war
                            self.currentWar = war
                        })
                        .disposed(by: self.disposeBag)
                } else {
                    preferences.currentWar = war
                    self.currentWar = war
                }
            }
            database.wars()
                .filter { !$0.isEmpty }
                .compactMap { wars in
                        let array =  wars
                        .map { MKWar(sdWar: $0) }
                        .sorted { first, second in first.mid > second.mid }
                    return switch(array.count > 5) {
                    case true : Array(array[0...4])
                    default: array
                    }                    
                }
                .subscribe(onNext: {
                    self.loadingState = nil
                    self.warList = $0
                }).disposed(by: self.disposeBag)
    
        }
    
    }
    
    func initFirstLaunch() {
        if (preferences.firstLaunch) {
            database.wars()
                .filter { !$0.isEmpty }
                .compactMap { wars in
                        let array =  wars
                        .map { MKWar(sdWar: $0) }
                        .sorted { first, second in first.mid > second.mid }
                    return Array(array[0...4])
                }
                .subscribe(onNext: {
                    self.loadingState = nil
                    self.warList = $0
                }).disposed(by: self.disposeBag)
            preferences.firstLaunch = false
        }
    }
    
}
