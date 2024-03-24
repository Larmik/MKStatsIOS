//
//  TrackListView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 28/01/2024.
//

import SwiftUI

struct TrackListView: View {
    
    @ObservedObject var viewModel: TrackListViewModel
    
    let onBack: () -> Void
    let warTrackIndex: Int?
    let onTrackSelected: (Maps) -> Void
    
    let title: String
    
    init(viewModel: TrackListViewModel,  warTrackIndex: Int?, onBack: @escaping () -> Void, onTrackSelected: @escaping (Maps) -> Void) {
        self.viewModel = viewModel
        self.warTrackIndex = warTrackIndex
        self.onBack = onBack
        self.onTrackSelected = onTrackSelected
        self.title = switch warTrackIndex {
        case nil: "Prochain circuit"
        default: "Editer circuit"
        }
        
    }
    var body: some View {
        HeaderScreenView(title: self.title, showBackButton: true, onBack: onBack) {
            VStack { 
                MKTextFieldView(passwordMode: false, placeHolder: "Rechercher un circuit", onValueChange:  { value in
                    viewModel.onSearch(searched: value)
                })
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.maps, id: \.self) { map in
                            MKWarTrackCellView(track: MKWarTrack(map: map), showCup: true, onClick: {
                                switch warTrackIndex {
                                case nil:
                                    viewModel.addTrack(index: map.trackIndex)
                                    onTrackSelected(map)
                                default: viewModel.editTrack(indexInList: warTrackIndex!, newTrackIndex: Maps.allCases.firstIndex(of: map)!, onTrackEdited: {
                                    onBack()
                                    onTrackSelected(map)
                                })
                                }
                            })
                            
                        }
                    }
                }
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
        
        }
    }
}
