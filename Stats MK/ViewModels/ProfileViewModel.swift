//
//  ProfileViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 21/01/2024.
//

import Foundation

@MainActor class ProfileViewModel : ObservableObject, Identifiable {
    
    private let authenticationRepository: AuthenticationRepository
    private let databaseRepository: DatabaseRepository
    
    init(authenticationRepository: AuthenticationRepository, databaseRepository: DatabaseRepository) {
        self.authenticationRepository = authenticationRepository
        self.databaseRepository = databaseRepository
    }
    
    func onLogout(onSuccess: @escaping () -> Void) {
        databaseRepository.clearRoster()
        databaseRepository.clearWars()
        authenticationRepository.logout()
        onSuccess()
    }
    
   
    
    
}
