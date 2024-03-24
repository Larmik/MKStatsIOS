//
//  NavigationView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

struct NavigationView: View {
    
    @State var selectedTab = 0
    
    let registryView: RegistryMenuView
    let warView: WarView
    let statsMenuView: StatsMenuView
    
    var body: some View {
      
        ZStack(alignment: .bottom) {
            switch (selectedTab) {
            case 1: 
                statsMenuView
            case 2:
                registryView
            default:
                warView
            }
            MKBottomBarView(
                onSelectedTab: { tab in selectedTab = tab }
            )
        }
    }
}
