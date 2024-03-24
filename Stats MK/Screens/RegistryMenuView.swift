//
//  RegistryMenuView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

struct RegistryMenuView: View {
    
    let onProfileClick: () -> Void
    
    var body: some View {
        HeaderScreenView(title: "Registre", content: {
            LazyVStack {
                ForEach(MenuItems.allCases.filter { item in item.type == "Registry" } , id: \.self) { item in
                    MKListItem(item: item, onNavigate: { _ in}, onClick: { item in
                        switch (item) {
                        case .profil: onProfileClick()
                        default: ()
                        
                        }
                    })
                }
            }
        })
    }
}
