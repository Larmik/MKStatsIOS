//
//  WarTrackResultView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/02/2024.
//

import SwiftUI

struct WarTrackResultView: View {
    
    
    @ObservedObject var viewModel: WarTrackResultViewModel
    let onBack: () -> Void
    let onValidate: () -> Void
    
    var body: some View {
        HeaderScreenView(title: viewModel.war?.warName ?? "", showBackButton: true, onBack: onBack) {
            VStack {
                MKWarTrackCellView(track: viewModel.track, showCup: true, onClick: {})
                VStack {
                    VStack {
                        ForEach(viewModel.warPos ?? []) { position in
                            MKPlayerItem(
                                position: position,
                                shockCount: viewModel.shocks?.first(where: { shock in shock.playerId == position.mkcPlayer?.mkcId })?.count ?? 0,
                                shockVisible: true,
                                onAddShock: { viewModel.onAddShock(playerId: $0) },
                                onRemoveShock: { viewModel.onRemoveShock(playerId: $0) }
                            )
                        }
                    }
                    MKScoreView(track: viewModel.track)
                    MKButtonView(label: "Valider", onClick: {
                        viewModel.onValid()
                        onValidate()
                    })
                }.padding(.horizontal, 10)
                    .padding(.vertical, 10)
            }
        }
    }
}
