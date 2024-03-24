//
//  TeamListView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/01/2024.
//

import SwiftUI

struct TeamListView: View {
    
    @ObservedObject var viewModel: TeamListViewModel
    let onBack: () -> Void
    let onTeamClick: (String) -> Void

    var body: some View {
        HeaderScreenView(title: "Nouvelle war", subtitle: "Sélectionnez un adversaire", showBackButton: true, onBack: onBack, content: {
            VStack {
                MKTextFieldView(passwordMode: false, placeHolder: "Rechercher un adversaire...", onValueChange: { value in
                    viewModel.onSearch(searched: value)
                })
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.teams ?? []) { item in
                           MKTeamItem(team: item, onClick: onTeamClick)
                        }
                    }
                }
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
          
        })
    }
}
