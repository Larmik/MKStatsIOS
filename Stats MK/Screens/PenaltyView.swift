//
//  PenaltyView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/02/2024.
//

import SwiftUI

struct PenaltyView: View {
    
    @ObservedObject var viewModel: PenaltyViewModel
    let onBack: () -> Void

    var body: some View {
        HeaderScreenView(title: "Pénalité", showBackButton: true, onBack: onBack, content: {
            VStack {
                MKSegmentedSelector(itemsList: [viewModel.team1?.team_name ?? "", viewModel.team2?.team_name ?? ""], defaultValue: viewModel.team1?.team_name ?? "", onValueChange: { selectedTeamName in viewModel.onSelectTeam(team: selectedTeamName)
                    
                })
                MKTextFieldView(passwordMode: false, placeHolder: "Valeur", type: .numberPad, onValueChange:  { penaltyValue in
                    viewModel.onAmount(amount: penaltyValue)
                })
                MKButtonView(label: "Infliger la pénalité", onClick: {
                    viewModel.onPenaltyAdded {
                        onBack()
                    }
                })
            }
         
        })
    }
}

