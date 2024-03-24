//
//  AuthenticationRepository.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import FirebaseAuth

enum AuthUserResponse {
    case success(User)
    case failure(String)
    
    public var successResponse: User? {
        switch self {
        case .success(let response): return response
        default: return nil
        }
    }

    var failureResponse: String? {
        switch self {
        case .failure(let response): return response
        default: return nil
        }
    }
}

protocol AuthenticationRepositoryProtocol {
    func logIn(email: String, password: String, onResponse: @escaping (AuthUserResponse) -> Void)
    func signUp(email: String, password: String, onResponse: @escaping (AuthUserResponse) -> Void)
    func resetPassword(email: String, onResponse: @escaping () -> Void)
    func logout()
    var user: User? { get }
    var role: Int { get }
    
}

class AuthenticationRepository: AuthenticationRepositoryProtocol {
    
    init(preferencesRepository: PreferencesRepository) {
        self.preferencesRepository = preferencesRepository
    }
    
    var role: Int {
        get { return preferencesRepository.role }
    }
    
    
    let preferencesRepository: PreferencesRepository
    
    func resetPassword(email: String, onResponse: @escaping () -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            onResponse()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
        
    var user: User? = Auth.auth().currentUser

    
    func signUp(email: String, password: String, onResponse: @escaping (AuthUserResponse) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {  authResult, error in
            if (authResult?.user != nil) {
                onResponse(AuthUserResponse.success(authResult!.user))
            } else {
                onResponse(AuthUserResponse.failure(error?.localizedDescription ?? "Unknown error"))
            }
        }
    }
    
    
    func logIn(email: String, password: String, onResponse: @escaping (AuthUserResponse) -> Void)  {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if (authResult?.user != nil) {
               onResponse(AuthUserResponse.success(authResult!.user))
            } else {
                onResponse(AuthUserResponse.failure(error?.localizedDescription ?? "Unknown error"))
            }
        }
    }
    

    
}

