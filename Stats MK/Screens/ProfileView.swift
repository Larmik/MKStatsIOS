//
//  ProfileView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

struct ProfileView: View {
    
    let onBack: () -> Void
    let onLogout: () -> Void
    
    @ObservedObject var viewModel: ProfileViewModel

    
    var body: some View {
        HeaderScreenView(title: "Profil", showBackButton: true, onBack: onBack, content: {
            LazyVStack {
                ForEach(MenuItems.allCases.filter { item in item.type == "Profile" } , id: \.self) { item in
                    MKListItem(item: item, onNavigate: { _ in }, onClick: { item in
                        switch (item) {
                        case .logout: viewModel.onLogout() {
                            self.onLogout()
                        }
                        default: ()
                        }
                    })
                }
            }
        })
    }
}
