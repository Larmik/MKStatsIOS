//
//  Router.swift
//  Stats MK
//
//  Created by Pascal Alberti on 17/01/2024.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case login
        case signup
        case main
        case forgotPassword
        case profile
        case warDetails(warId: String)
        case trackDetails(warId: String, trackId: String, trackIndex: Int?, warTrackIndex: Int?)
        case currentWar
        case teamList
        case playersList(teamId: String)
        case trackList
        case positions(trackIndex: Int)
        case warTrackResult(trackIndex: Int)
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        if (!navPath.isEmpty) {
            navPath.removeLast()
        }
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
        navPath.append(Destination.login)
    }
    
    func navigateToHome() {
        navPath.removeLast(navPath.count)
        navPath.append(Destination.main)
    }
}
