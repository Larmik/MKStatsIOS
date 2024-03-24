//
//  CurrentWarView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 23/01/2024.
//

import SwiftUI

struct CurrentWarView: View {
    
    @ObservedObject var viewModel: CurrentWarViewModel
    @ObservedObject var subViewModel: SubPlayerViewModel
    @ObservedObject var penaltyViewModel: PenaltyViewModel
    @State var popupType: String? = nil
    @State var bottomSheetType: String? = nil
    let onBack: () -> Void
    let onTrackClick: (String, String, Int, Int?) -> Void
    let onNextTrackClick: () -> Void
    let onWarFinish: () -> Void
    
    var body: some View {
        
        HeaderScreenView(title: viewModel.war?.warName ?? "", subtitle: viewModel.war?.displayedState ?? "", showBackButton: true, onBack: onBack) {
          
            VStack {
                if (viewModel.buttonsVisible) {
                    MKSegmentedButtonsView(type: "Current", onCancelWarClick: {
                        popupType = "cancel"
                    }, onSubPlayerClick: {
                        bottomSheetType = "sub"
                    }, onPenaltyClick: {
                        bottomSheetType = "penalty"
                    })
                }
               
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
                        
                    
                    }.padding(.horizontal, 10)
                    
                if (viewModel.buttonsVisible) {
                    let label = switch (true) {
                    case viewModel.war?.isOver: "Valider la war"
                    default:"Prochaine course"
                    }
                    MKButtonView(label: label) {
                        switch (true) {
                        case viewModel.war?.isOver: popupType = "validate"
                        default: self.onNextTrackClick()
                       }
                    }.padding(.vertical, 5)
                }
                  
                    
                    if (!(viewModel.war?.warTracks.isEmpty ?? true)) {
                        
                        MKTextView(label: "Circuits joués :", font: "Montserrat-Bold")
                            .padding(.top, 5)
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.war?.warTracks.sorted { first, second in first.mid < second.mid } ?? []) { track in
                                    MKWarTrackCellView(track: track, onClick: {
                                        self.onTrackClick(viewModel.war?.mid ?? "", track.mid, track.trackIndex, viewModel.war?.warTracks.firstIndex(where: { t in t.mid == track.mid }))
                                    })
                                    Spacer().frame(height: 5)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                        }
                    }
            }.onAppear {
                viewModel.initFirstLaunch()
            }.alert(isPresented: .constant(popupType != nil), content: {
                let title = switch popupType {
                case "cancel": "Annuler la war"
                case "validate": "Valider la war"
                default: ""
                }
                let message = switch popupType {
                case "cancel": "Êtes-vous sûr de vouloir annuler la war ?"
                case "validate": "Une fois la war validée, vous ne pourrez plus la modifier."
                default: ""
                }
                return Alert(
                    title: Text(title),
                    message: Text(message),
                    primaryButton: Alert.Button.default(Text("Valider"), action: {
                        switch popupType {
                        case "cancel": viewModel.cancelWar(onFinish: {
                            onBack()
                        })
                        case "validate": viewModel.validateWar(onFinish: {
                            onBack()
                        })
                        default: ()
                        }
                       
                    }),
                    secondaryButton: Alert.Button.cancel(Text("Retour"), action: {
                        popupType = nil
                    }))
            })
            .popover(isPresented: .constant(bottomSheetType != nil), content: {
                switch (bottomSheetType) {
                case "sub": SubPlayerView(viewModel: subViewModel, onBack: {
                    bottomSheetType = nil
                }).interactiveDismissDisabled()
                case "penalty": PenaltyView(viewModel: penaltyViewModel, onBack: {
                    bottomSheetType = nil
                }).interactiveDismissDisabled()
                default: Spacer()
                }
               
            })
         
        }
    }
}


