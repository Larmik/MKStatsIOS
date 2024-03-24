//
//  StatsMenuView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

struct StatsMenuView: View {
    var body: some View {
        HeaderScreenView(title: "Statistiques", content: {
            LazyVStack {
                ForEach(MenuItems.allCases.filter { item in item.type == "Stats" } , id: \.self) { item in
                    MKListItem(item: item, onNavigate: { _ in}, onClick: { _ in})
                }
            }
        })
    }
}
