//
//  SplashScreenView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 28/01/2024.
//

import SwiftUI

struct SplashScreenView: View {
    
    @ObservedObject var viewModel: SplashScreenViewModel
    
    var body: some View {
        HeaderScreenView(title: "Connexion") {
            VStack {
                Spacer()
                    ProgressView( label: {
                        MKTextView(label: viewModel.loadingState ?? "Veuillez patienter", font: "Montserrat-Bold", fontSize: 16)
                    }).progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(hexColor: .harmoniaDark))))
                        .frame(maxHeight: .infinity)
            }.padding(.horizontal, 10)
        }
    }
}
