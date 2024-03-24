//
//  LoginViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import RxSwift

class LoginViewModel : ObservableObject, Identifiable {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    @Published private(set) var loadingState: String?
    
    let onLoginSuccess: () -> Void
    let authenticationRepository: AuthenticationRepository
    let preferencesRepository: PreferencesRepository
    let fetchUseCase: FetchUseCase
    
    init(onLoginSuccess: @escaping () -> Void, authenticationRepository: AuthenticationRepository, preferencesRepository: PreferencesRepository, fetchUseCase: FetchUseCase) {
        self.onLoginSuccess = onLoginSuccess
        self.authenticationRepository = authenticationRepository
        self.preferencesRepository = preferencesRepository
        self.fetchUseCase = fetchUseCase
    }
    
    @MainActor func onConnect(email: String, password: String) {
        authenticationRepository.logIn(email: email, password: password) { user in
            print("auth succeeded, set email and password")
            self.preferencesRepository.authEmail = email
            self.preferencesRepository.authPassword = password
            print("beginning of fetch...")
            self.loadingState = "Récupération du joueur..."
            self.fetchUseCase.fetchPlayer(id: user.successResponse?.uid ?? "").map { _ in Void() }
                .do(onCompleted: { self.loadingState = "Récupération de l'équipe..." })
                .concat(self.fetchUseCase.fetchPlayers())
                .do(onCompleted: { self.loadingState = "Récupération des adversaires..." })
                .concat(self.fetchUseCase.fetchTeams())
                .do(onCompleted: { self.loadingState = "Récupération des wars..." })
                .concat(self.fetchUseCase.fetchWars())
                .do(onCompleted: { self.loadingState = "Ecriture des statistiques..." })
                .subscribe(onCompleted: { self.onLoginSuccess() })
                .disposed(by: self.disposeBag)
        }
    }
    
}

