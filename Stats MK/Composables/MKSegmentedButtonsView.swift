//
//  MKSegmentedButtonsView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

enum SegmentedButton: String, CaseIterable {
    
    case createWar = "War/1"
    case sub = "Current/1"
    case penalty = "Current/2"
    case cancel = "Current/3"
    case editTrack = "Track/1"
    case editPositions = "Track/2"
    case editShocks = "Track/3"
    
    var title: String {
        switch (self) {
        case .createWar:
            return "Créer une war"
        case .sub:
            return "Remplacement"
        case .penalty:
            return "Pénalité"
        case .cancel:
            return "Annuler le match"
        case .editTrack:
            return "Editer circuit"
        case .editPositions:
            return "Editer positions"
        case .editShocks:
            return "Editer shocks"
        }
    }
    
    var type: String {
        return String(self.rawValue.split(separator: "/")[0])
    }
    
    var rawValue: Int {
        return Int(self.rawValue.split(separator: "/")[1])!
    }
    
}

struct MKSegmentedButtonsView: View {
    
    let buttons: [SegmentedButton]
    let onCreateWarClick: () -> Void
    let onCancelWarClick: () -> Void
    let onSubPlayerClick: () -> Void
    let onPenaltyClick: () -> Void
    let onEditTrackClick: () -> Void
    let onEditPositionClick: () -> Void
    let onEditShockClick: () -> Void

    
    init(
        type: String,
        onCreateWarClick: @escaping () -> Void = {()},
        onCancelWarClick: @escaping () -> Void = {()},
        onSubPlayerClick: @escaping () -> Void = {()},
        onPenaltyClick: @escaping () -> Void = {()},
        onEditTrackClick: @escaping () -> Void = {()},
        onEditPositionClick: @escaping () -> Void = {()},
        onEditShockClick: @escaping () -> Void = {()}
    ) {
        self.buttons = SegmentedButton.allCases.filter { button in button.type == type }
        self.onCreateWarClick = onCreateWarClick
        self.onCancelWarClick = onCancelWarClick
        self.onSubPlayerClick = onSubPlayerClick
        self.onPenaltyClick = onPenaltyClick
        self.onEditTrackClick = onEditTrackClick
        self.onEditPositionClick = onEditPositionClick
        self.onEditShockClick = onEditShockClick
    }
    
    
    var body: some View {
        HStack {
            ForEach(self.buttons, id: \.self) { button in
                MKTextView(label: button.title, font: "Roboto-Bold")
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        switch (button) {
                        case .createWar: onCreateWarClick()
                        case .sub: onSubPlayerClick()
                        case .penalty: onPenaltyClick()
                        case .cancel: onCancelWarClick()
                        case .editTrack: onEditTrackClick()
                        case .editShocks: onEditShockClick()
                        case .editPositions: onEditPositionClick()
                        }
                    }
                if (button.rawValue < buttons.count) {
                    Spacer()
                        .frame(maxHeight: .infinity)
                        .frame(width: 1)
                        .background(Color(UIColor(hexColor: .harmoniaDark)))
                }
            }
        }
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .background(Color(UIColor.white.withAlphaComponent(0.5)))
    }
}
