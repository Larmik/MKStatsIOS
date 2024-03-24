//
//  WarDetailsView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/01/2024.
//

import SwiftUI

struct WarDetailsView: View {
    
    @ObservedObject var viewModel: WarDetailsViewModel
    let onBack: () -> Void
    let onTrackClick: (String, String) -> Void
    
    

    var body: some View {
        
        let bestTrack = viewModel.war?.warTracks.sorted { first, second in first.diffScore > second.diffScore}.first
        let worstTrack = viewModel.war?.warTracks.sorted { first, second in first.diffScore < second.diffScore}.first
        
        HeaderScreenView(title: viewModel.war?.warName ?? "", subtitle: viewModel.war?.createdDate ?? "", showBackButton: true, onBack: onBack) {
            VStack {
                VStack {
                    ZStack(alignment: .center) {
                        HStack {
                            MKPenaltyView(penalties: viewModel.war?.penalties ?? [])
                            Spacer().frame(maxWidth: .infinity)
                            MKShockView(tracks: viewModel.war?.warTracks ?? [])
                        }.frame(maxWidth: .infinity)
                        MKScoreView(war: viewModel.war)
                    }.frame(maxWidth: .infinity)
                    
                    
                    MKCurrentPlayersListView(players: viewModel.players)
                    
                    HStack {
                        VStack {
                            MKTextView(label: "Meilleur circuit", font: "Montserrat-Bold")
                                .padding(.top, 5)
                            MKWarTrackCellView(track: bestTrack, isVertical: true, onClick: {
                                self.onTrackClick(viewModel.war?.mid ?? "", bestTrack?.mid ?? "")
                            })
                        }
                        VStack {
                            MKTextView(label: "Pire circuit", font: "Montserrat-Bold")
                                .padding(.top, 5)
                            MKWarTrackCellView(track: worstTrack, isVertical: true, onClick: {
                                self.onTrackClick(viewModel.war?.mid ?? "", worstTrack?.mid ?? "")
                            })
                        }
                    }
                }.padding(.horizontal, 10)
                
                MKTextView(label: "Circuits joués :", font: "Montserrat-Bold")
                    .padding(.top, 5)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.war?.warTracks.sorted { first, second in first.mid < second.mid } ?? []) { track in
                            MKWarTrackCellView(track: track, onClick: {
                                self.onTrackClick(viewModel.war?.mid ?? "", track.mid)
                            })
                            Spacer().frame(height: 5)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
            }.padding(.top, 10)
        }
    }
    
}

