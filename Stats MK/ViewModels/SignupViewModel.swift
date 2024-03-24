//
//  SignupViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation

class SignupViewModel : ObservableObject, Identifiable {
    
    private let authRepository: AuthenticationRepository
    private let firebaseRepository: FirebaseRepository
    
    let onSignupSuccess: () -> Void
    
    init(authenticationRepository: AuthenticationRepository, firebaseRepository: FirebaseRepository, onSignupSuccess: @escaping () -> Void) {
        self.authRepository = authenticationRepository
        self.firebaseRepository = firebaseRepository
        self.onSignupSuccess = onSignupSuccess
    }
        
  
    func onConnect(pseudo: String, email: String, password: String) -> Void {
        
        authRepository.signUp(email: email, password: password, onResponse: {[weak self] response in
            guard let self = self else { return }
            switch (response) {
            case .success:
                guard let user = response.successResponse else { return }
                let fbUser = FBUser(mid: user.uid, name: pseudo, currentWar: "-1", role: 0, picture: "", mkcId: "", discordId: "")
                self.firebaseRepository.writeUser(user: fbUser)
                self.onSignupSuccess()
            
            default: ()
            }
            
        })
        
    }
    
}
