//
//  TeamListViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/01/2024.
//

import Foundation
import RxSwift

@MainActor class TeamListViewModel : ObservableObject, Identifiable {
    
    
    @Published private(set) var teams: [MKCTeam]?
    var teamList: [MKCTeam]?
    private let disposeBag: DisposeBag = DisposeBag()

    

    init(databaseRepository: DatabaseRepository) {
        databaseRepository.teams()
            .map { teams in
                teams.map{ MKCTeam(sdTeam: $0) }
            }
            .subscribe(onNext: {
                self.teamList = $0
                self.teams = $0
            }).disposed(by: self.disposeBag)
        
    }
    
    func onSearch(searched: String) {
        switch (true) {
        case searched.isEmpty: self.teams = self.teamList
        default: self.teams = self.teamList?.filter { team in team.team_name.lowercased().contains(searched.lowercased()) || team.team_tag.lowercased().contains(searched.lowercased()) }
        }
    }
    
    
   
    
    
}

