//
//  SubPlayerView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/02/2024.
//

import SwiftUI

struct SubPlayerView: View {
    
    @ObservedObject var viewModel: SubPlayerViewModel
    let onBack: () -> Void
    
    var body: some View {
        HeaderScreenView(title: viewModel.title, showBackButton: true, onBack: {
            switch (viewModel.playerSelected) {
            case nil: onBack()
            default: viewModel.onBack()
            }
        }, content: {
            VStack {
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(content: {
                            ForEach(viewModel.players) { item in
                                MKPlayerItem(player: item, onClick: {
                                    switch (viewModel.playerSelected) {
                                    case nil: viewModel.onOldPlayerSelect(user: item.player)
                                    default: viewModel.onNewPlayerSelect(user: item.player)
                                    }
                                })
                            }
                        }, header: {
                            VStack {
                                if (viewModel.players.count > 0) {
                                    MKTextView(label: "Roster", font: "Montserrat-Bold", fontSize: 16, fontColor: Color(UIColor(hexColor: .white)))
                                        .padding(.vertical, 10)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor(hexColor: .harmoniaDark)))
                        })
                        Section(content: {
                            ForEach(viewModel.allies) { item in
                                MKPlayerItem(player: item, onClick: {
                                    switch (viewModel.playerSelected) {
                                    case nil: viewModel.onOldPlayerSelect(user: item.player)
                                    default: viewModel.onNewPlayerSelect(user: item.player)
                                    }
                                })
                            }
                        }, header: {
                            VStack {
                                if (viewModel.allies.count > 0) {
                                    MKTextView(label: "Allies", font: "Montserrat-Bold", fontSize: 16, fontColor: Color(UIColor(hexColor: .white)))
                                        .padding(.vertical, 10)
                                }
                             
                            }.frame(maxWidth: .infinity)
                                .background(Color(UIColor(hexColor: .harmoniaDark)))
                        })
                    }
                }
                if (viewModel.playerSelected != nil) {
                    MKButtonView(label: "Remplacer \(viewModel.playerSelected!.name)", onClick: {
                        viewModel.onSubClick {
                            onBack()
                        }
                    })
                }
            }
        })
    }
}
