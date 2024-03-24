//
//  LoginView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import SwiftUI

struct LoginView: View {
    
    var onSignupClick: () -> Void
    
    @State var email = ""
    @State var password = ""
    
    @ObservedObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel, onSignupClick: @escaping () -> Void, email: String = "", password: String = "") {
        self.viewModel = viewModel
        self.onSignupClick = onSignupClick
        self.email = email
        self.password = password
    }
    
    var body: some View {
        HeaderScreenView(title: "Connexion", content: {
            VStack {
                Spacer()
                if (viewModel.loadingState != nil) {
                    ProgressView( label: {
                        MKTextView(label: viewModel.loadingState ?? "Veuillez patienter", font: "Montserrat-Bold", fontSize: 16)
                    }).progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(hexColor: .harmoniaDark))))
                        .frame(maxHeight: .infinity)
                } else {
                    MKTextFieldView(passwordMode: false, placeHolder: "Entrez votre adresse email:", type: .emailAddress, onValueChange: { value in self.email = value })
                    MKTextFieldView(passwordMode: true, placeHolder: "Entrez votre mot de passe:", onValueChange: { value in self.password = value })
                    MKButtonView(label: "Se connecter") {
                        viewModel.onConnect(email: self.email, password: self.password)
                    }.padding(.vertical, 5)
                    Spacer()
                    MKTextView(label: "Mot de passe oublié ?").padding(.vertical, 5)
                    MKTextView(label: "Nouveau sur l'appli ?").padding(.vertical, 5).onTapGesture {
                        self.onSignupClick()
                    }
                }
              
            }.padding(.horizontal, 10)
             
        })
    }
}
