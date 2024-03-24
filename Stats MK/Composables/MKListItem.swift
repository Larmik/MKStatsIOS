//
//  MKListItem.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import SwiftUI

enum MenuItems:  CaseIterable {
    
    case team
    case opponents
    case players
    case profil
    case indivStats
    case teamStats
    case playerStats
    case opponentStats
    case mapStats
    case periodicStats
    case changeEmail
    case changePassword
    case logout
    
    var title: String{
        switch self {
        case .team:
            return "Mon équipe"
        case .opponents:
            return "Adversaires"
        case .players:
            return "Joueurs"
        case .profil:
            return "Profil"
        case .indivStats:
            return "Statistiques individuelles"
        case .teamStats:
            return "Statistiques de l'équipe"
        case .playerStats:
            return "Statistiques des joueurs"
        case .opponentStats:
            return "Statistiques des adversaires"
        case .mapStats:
            return "Statistiques des circuits"
        case .periodicStats:
            return "Statistiques périodiques"
        case .changeEmail:
            return "Changer mon email"
        case .changePassword:
            return "Changer mon mot de passe"
        case .logout:
            return "Se déconnecter"
    
        }
    }
    
    var type: String{
        switch self {
        case .team, .profil, .players, .opponents:
            return "Registry"
        case .changeEmail, .changePassword, .logout:
            return "Profile"
        default:
            return "Stats"
       
        }
    }
    
}

struct MKListItem: View {
    
    let item: MenuItems
    let onNavigate: (String) -> Void
    let onClick: (MenuItems) -> Void
    
    
    var body: some View {
        Button(action: {onClick(item)}, label: {
            VStack(alignment: .leading) {
                MKTextView(label: item.title)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                if (item.type != "Profile") {
                    Spacer()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                }
            }
            .frame(maxWidth: .infinity)
        })
       
        
    }
}
