//
//  TrackListViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 22/02/2024.
//

import Foundation

class TrackListViewModel : ObservableObject, Identifiable {
    
    private let preferences: PreferencesRepository
    private let firebase: FirebaseRepository
    
    @Published private(set) var maps: [Maps] = Maps.allCases

    
    init(preferences: PreferencesRepository, firebase: FirebaseRepository) {
        self.preferences = preferences
        self.firebase = firebase
    }
    
    func addTrack(index: Int) {
        var timeMillis = String(Date().timeIntervalSince1970)
        timeMillis.removeLast(3)
        preferences.currentWarTrack = MKWarTrack(mid: timeMillis.replacing(".", with: ""), index: index, positions: [])
    }
    
    func editTrack(indexInList: Int, newTrackIndex: Int, onTrackEdited: @escaping () -> Void) {
        var war = preferences.currentWar
        var track = war?.warTracks[indexInList]
        var newTrackList = [MKWarTrack]()
        newTrackList.append(contentsOf: war?.warTracks ?? [])
        newTrackList.removeAll(where: { track?.mid == $0.mid })
        track?.trackIndex = newTrackIndex
        newTrackList.insert(track!, at: indexInList)
        war?.warTracks = newTrackList
        firebase.writeCurrentWar(war: FBWar(war: war!))
        preferences.currentWar = war
        onTrackEdited()
   }
    
    func onSearch(searched: String) {
        switch (true) {
        case searched.isEmpty: self.maps = Maps.allCases
        default: self.maps = Maps.allCases.filter { map in map.label.lowercased().contains(searched.lowercased()) || map.rawValue.lowercased().contains(searched.lowercased()) }
        }
    }
}
