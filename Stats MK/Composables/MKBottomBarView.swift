//
//  MKBottomBarView.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

enum NavItems: Int, CaseIterable {
    
    case war = 0
    case stats
    case registry
    
    var title: String{
        switch self {
        case .war:
            return "War en équipe"
        case .stats:
            return "Statistiques"
        case .registry:
            return "Registre"
       
        }
    }
    
    var iconName: String{
        switch self {
        case .war:
            return "teamwar"
        case .stats:
            return "stats"
        case .registry:
            return "registry"
        }
    }
}

struct MKBottomBarView: View {
    
    @State var selectedTab = 0
    
    var onSelectedTab: (Int) -> Void
    
    init(onSelectedTab: @escaping (Int) -> Void) {
        self.onSelectedTab = onSelectedTab
    }
    
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
           HStack(spacing: 10){
               Spacer()
               VStack {
                   Image(imageName)
                       .resizable()
                       .renderingMode(.template)
                       .foregroundColor(isActive ? .white : .gray)
                       .frame(width: 35, height: 35)
                   Text(title)
                       .font(.system(size: 12))
                       .foregroundColor(isActive ? .white : .gray)
               }
               Spacer()
           }
           .frame(maxWidth: .infinity, maxHeight: 60)
           .cornerRadius(30)
       }
    
    var body: some View {
        ZStack{
            HStack{
                ForEach(NavItems.allCases, id: \.self){ item in
                    Button{
                        selectedTab = item.rawValue
                        self.onSelectedTab(item.rawValue)
                    } label: {
                        CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                    }
                }
            }
            .padding(6)
        }
        .frame(height: 60)
        .background(Color(UIColor(hexColor: .harmoniaDark)))
    }
}
