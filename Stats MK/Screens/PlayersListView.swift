//
//  PlayersListView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/01/2024.
//

import SwiftUI


struct PlayersListView: View {
    
    @ObservedObject var viewModel: PlayersListViewModel
    let onBack: () -> Void
    let onWarCreated: () -> Void
    
    @State var isChecked = false
    
    var body: some View {
        
        HeaderScreenView(title: "Nouvelle war", subtitle: viewModel.warName ?? "", showBackButton: true, onBack: onBack, content: {
            VStack {
                
                if (viewModel.loadingState != nil) {
                    Spacer()
                    ProgressView( label: {
                        MKTextView(label: viewModel.loadingState ?? "Veuillez patienter", font: "Montserrat-Bold", fontSize: 16)
                    }).progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(hexColor: .harmoniaDark))))
                        .frame(maxHeight: .infinity)
                    Spacer()
                } else {
                    MKTextView(label: "Sélectionnez les six joueurs de votre équipe")
                    ScrollView {
                        LazyVStack(pinnedViews: [.sectionHeaders]) {
                            Section(content: {
                                ForEach(viewModel.players ?? []) { item in
                                    MKPlayerItem(player: item, onClick: {
                                        let newItem = UserSelector(mkcPlayer: item.player, selected: !item.selected)
                                        viewModel.selectUser(user: newItem)
                                    })
                                }
                            }, header: {
                                VStack {
                                    MKTextView(label: "Roster", font: "Montserrat-Bold", fontSize: 16, fontColor: Color(UIColor(hexColor: .white)))
                                        .padding(.vertical, 10)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor(hexColor: .harmoniaDark)))
                            })
                            Section(content: {
                                ForEach(viewModel.allies ?? []) { item in
                                    MKPlayerItem(player: item, onClick: {
                                        let newItem = UserSelector(mkcPlayer: item.player, selected: !item.selected)
                                        viewModel.selectAlly(user: newItem)
                                    })
                                }
                            }, header: {
                                VStack {
                                    MKTextView(label: "Allies", font: "Montserrat-Bold", fontSize: 16, fontColor: Color(UIColor(hexColor: .white)))
                                        .padding(.vertical, 10)
                                }.frame(maxWidth: .infinity)
                                    .background(Color(UIColor(hexColor: .harmoniaDark)))
                            })
                        }
                    }
                    Toggle(isOn: $isChecked) {
                        MKTextView(label: "War officielle")
                    }
                    .toggleStyle(SwitchToggleStyle())
                    .padding(.horizontal, 100)
                    .padding(.vertical, 10)
                    MKButtonView(
                        label: "Valider",
                        enabled: viewModel.enabled,
                        onClick: { viewModel.createWar(official: isChecked, onFinish: {
                            onWarCreated()
                        }) })
                }
            }.padding(.horizontal, 10)
                .padding(.vertical, 10)
        })
    }
}
