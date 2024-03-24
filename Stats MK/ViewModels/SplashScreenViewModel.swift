//
//  SplashScreenViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 28/01/2024.
//

import Foundation
import RxSwift

@MainActor class SplashScreenViewModel : ObservableObject, Identifiable {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    @Published private(set) var loadingState: String?
    
    init(onFetchSuccess: @escaping () -> Void, authenticationRepository: AuthenticationRepository, preferencesRepository: PreferencesRepository, fetchUseCase: FetchUseCase) {
        guard let id = authenticationRepository.user?.uid else {
            return
        }
        fetchUseCase.fetchPlayer(id: id).map { _ in Void() }
            .do(onCompleted: { self.loadingState = "Récupération de l'équipe..." })
            .concat(fetchUseCase.fetchPlayers())
            .do(onCompleted: { self.loadingState = "Récupération des adversaires..." })
            .concat(fetchUseCase.fetchTeams())
            .do(onCompleted: { self.loadingState = "Récupération des wars..." })
            .concat(fetchUseCase.fetchWars())
            .subscribe(onCompleted: { 
                self.loadingState = nil
                onFetchSuccess()
            })
            .disposed(by: self.disposeBag)
    }
    
    
}

