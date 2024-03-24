//
//  TrackDetailsView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 24/01/2024.
//

import SwiftUI

struct TrackDetailsView: View {
    
    @ObservedObject var viewModel: TrackDetailsViewModel
    @ObservedObject var trackListViewModel: TrackListViewModel
    @ObservedObject var positionViewModel: PositionViewModel
    @ObservedObject var warTrackResultViewModel: WarTrackResultViewModel

    let onBack: () -> Void
    
    @State var bottomSheetType: String? = nil


    var body: some View {
        HeaderScreenView(title: viewModel.war?.warName ?? "", showBackButton: true, onBack: onBack) {
            VStack {
                MKWarTrackCellView(track: viewModel.track, map: viewModel.map, showCup: true, onClick: {})
                if (viewModel.canEdit) {
                    MKSegmentedButtonsView(type: "Track", onEditTrackClick: {
                        bottomSheetType = "editTrack"
                    }, onEditPositionClick: {
                        bottomSheetType = "editPositions"
                    }, onEditShockClick: {
                        bottomSheetType = "editShocks"
                    }
                    
                    ).offset(y: -7)
                }
                VStack {
                    VStack {
                        ForEach(viewModel.players) { position in
                            MKPlayerItem(
                                position: position,
                                shockCount: viewModel.track?.shocks.first(where: { shock in shock.playerId == position.mkcPlayer?.mkcId })?.count ?? 0,
                                shockVisible: false
                            )
                        }
                    }
                    MKScoreView(track: viewModel.track)
                }.padding(.horizontal, 10)
                    .padding(.vertical, 10)
            }.popover(isPresented: .constant(bottomSheetType != nil), content: {
                switch (bottomSheetType) {
                case "editTrack": TrackListView(
                    viewModel: trackListViewModel,
                    warTrackIndex: viewModel.war?.warTracks.firstIndex(where: { track in track.mid == viewModel.track?.mid}),
                    onBack: { bottomSheetType = nil },
                    onTrackSelected: { map in viewModel.setTrack(map: map) }
                ).interactiveDismissDisabled()
                case "editPositions": PositionView(
                    viewModel: positionViewModel,
                    onBack: { bottomSheetType = nil },
                    onTrackEdited: {
                        bottomSheetType = nil
                        viewModel.setPositions()
                    }
                ).interactiveDismissDisabled()
                case "editShocks":  WarTrackResultView(
                    viewModel: warTrackResultViewModel,
                    onBack: { bottomSheetType = nil },
                    onValidate: {
                        bottomSheetType = nil
                        viewModel.setPositions()
                    }
                ).interactiveDismissDisabled()
                default: Spacer()
                }
            })
          
        }
    }
    
}
