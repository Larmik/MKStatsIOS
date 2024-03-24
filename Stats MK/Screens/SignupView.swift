//
//  SignupView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import SwiftUI

struct SignupView: View {
    
    var onLoginCick: () -> Void
    @ObservedObject var viewModel: SignupViewModel
    
    @State var pseudo: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    init(viewModel: SignupViewModel, onLoginClick: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onLoginCick = onLoginClick
    }
    
    var body: some View {
        HeaderScreenView(title: "Bienvenue !", content: {
            VStack {
                Spacer()
                MKTextFieldView(passwordMode: false, placeHolder: "Entrez votre pseudo:", onValueChange: { value in
                   pseudo = value
                })
                MKTextFieldView(passwordMode: false, placeHolder: "Entrez votre adresse email:", type: .emailAddress, onValueChange: { value in email = value } )
                MKTextFieldView(passwordMode: true, placeHolder: "Entrez votre mot de passe:", onValueChange: { value in password = value } )
                MKTextFieldView(passwordMode: true, placeHolder: "Confirmation du mot de passe:", onValueChange: { value in } )
                MKButtonView(label: "Suivant") {
                    viewModel.onConnect(pseudo: pseudo, email: email, password: password)
                }.padding(.vertical, 5)
                Spacer()
                MKTextView(label: "Déjà sur l'appli ?")
                    .padding(.vertical, 5)
                    .onTapGesture { self.onLoginCick() }
            }.padding(.horizontal, 10)
        }
       )
    }
}
