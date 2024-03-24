//
//  WarView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

struct WarView: View {
    
    @StateObject var viewModel: WarViewModel
    
    let onWarClick: (String) -> Void
    let onCurrentWarClick: () -> Void
    let onCreateWarClick: () -> Void
    
    var body: some View {
        let teamName = viewModel.team?.team_name
        HeaderScreenView(title: "War en équipe", subtitle: teamName,  content: {
            VStack {
                
                if (viewModel.currentWar == nil) {
                    if (viewModel.buttonsVisible) {
                        MKSegmentedButtonsView(type: "War", onCreateWarClick: onCreateWarClick)
                    }
                } else {
                    VStack {
                        MKTextView(label: "War en cours", font: "Montserrat-Bold")
                            .padding(.top, 10)
                        MKCurrentWarCellView(war: viewModel.currentWar!, state: viewModel.loadingState, onClick: onCurrentWarClick)
                    }.padding(.horizontal, 10)
                }
                MKTextView(label: "Dernières wars", font: "Montserrat-Bold")
                    .padding(.top, 10)
                LazyVStack {
                    ForEach(viewModel.warList) { war in
                        MKWarCellView(war: war, onWarClick: onWarClick)
                        Spacer().frame(height: 5)
                    }
                }.padding(.horizontal, 10)
                    .padding(.top, 5)
                
                
            }.onAppear(perform: {
                viewModel.initFirstLaunch()
            })
        }
        )
    }
}
