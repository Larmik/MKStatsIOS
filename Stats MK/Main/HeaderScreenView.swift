//
//  HeaderScreenView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import SwiftUI

struct HeaderScreenView<Content: View>: View {
    
    let title: String
    let subtitle: String?
    let showBackButton: Bool
    let onBack: () -> Void
    @ViewBuilder let content: () -> Content
    
    init(title: String, subtitle: String? = nil, showBackButton: Bool = false, onBack: @escaping () -> Void = ({}), content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.content = content
    }
    
    var body: some View {
        VStack {
            VStack {
                ZStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(.custom("Montserrat-Bold", size: 22))
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                    if (showBackButton) {
                        Image("retour")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.horizontal, 20)
                            .onTapGesture { onBack() }
                    }
                }.frame(maxWidth: .infinity)
                if (subtitle != nil) {
                    Text(subtitle!)
                        .foregroundColor(Color.white)
                        .font(.custom("Montserrat-Regular", size: 18))
                        .padding(.bottom, 15)
                        .frame(maxWidth: .infinity)
                }
              
            }
            .frame(maxWidth: .infinity, alignment:.top)
            .background(Color(UIColor(hexColor: .harmoniaDark)))
            content().offset(y: -8)
        } 
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:.top)
        .background(Color(UIColor(hexColor: .harmoniaClear)))
        .navigationBarBackButtonHidden()
    }
}

