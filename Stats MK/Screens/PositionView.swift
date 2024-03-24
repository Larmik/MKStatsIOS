//
//  PositionView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 28/01/2024.
//

import SwiftUI

struct PositionView: View {
    
    
    @ObservedObject var viewModel: PositionViewModel
    let onBack: () -> Void
    let onTrackEdited: () -> Void
    
    var body: some View {
        HeaderScreenView(title: "Positions", showBackButton: true, onBack: onBack) {
            VStack {
                MKWarTrackCellView(track: MKWarTrack(map: viewModel.map ?? .MKS), showCup: true, onClick: {})
                MKTextView(label: "Sélectionnez la position de \(viewModel.playerLabel ?? "")", font: "Montserrat-Bold", fontSize: 16)
                    .padding(.vertical, 10)
                Spacer()
                HStack {
                    MKPositionView(position: 1, onClick: { viewModel.onPositionClick(position: 1, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(1) )
                    MKPositionView(position: 2, onClick: { viewModel.onPositionClick(position: 2, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(2)  )
                    MKPositionView(position: 3, onClick: { viewModel.onPositionClick(position: 3, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(3)  )
                   
                }.frame(maxWidth: .infinity)
                Spacer()
                HStack {
                    MKPositionView(position: 4, onClick: { viewModel.onPositionClick(position: 4, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(4)  )
                    MKPositionView(position: 5, onClick: { viewModel.onPositionClick(position: 5, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(5)  )
                    MKPositionView(position: 6, onClick: { viewModel.onPositionClick(position: 6, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(6)  )
                }.frame(maxWidth: .infinity)
                Spacer()
                HStack {
                    MKPositionView(position: 7, onClick: { viewModel.onPositionClick(position: 7, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(7)  )
                    MKPositionView(position: 8, onClick: { viewModel.onPositionClick(position: 8, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(8)  )
                    MKPositionView(position: 9, onClick: { viewModel.onPositionClick(position: 9, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(9)  )
                }.frame(maxWidth: .infinity)
                Spacer()
                HStack {
                    MKPositionView(position: 10, onClick: { viewModel.onPositionClick(position: 10, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(10)  )
                    MKPositionView(position: 11, onClick: { viewModel.onPositionClick(position: 11, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(11)  )
                    MKPositionView(position: 12, onClick: { viewModel.onPositionClick(position: 12, onTrackEdited: onTrackEdited)}, visible: !viewModel.selectedPositions.contains(12)  )
                }.frame(maxWidth: .infinity)

            }.padding(.vertical, 10)
                .padding(.horizontal, 10)
        }
    }
}
