//
//  PenaltyViewModel.swift
//  Stats MK
//
//  Created by Pascal Alberti on 25/02/2024.
//

import Foundation
import RxSwift

@MainActor class PenaltyViewModel : ObservableObject, Identifiable {
    
    
    private let firebase: FirebaseRepository
    private let database: DatabaseRepository
    private let preferences: PreferencesRepository
    private let disposeBag: DisposeBag = DisposeBag()
    
    @Published private(set) var team1: SDTeam? = nil
    @Published private(set) var team2: SDTeam? = nil
    
    private var teamSelected: SDTeam? = nil
    private var amount: Int? = nil
    
    init(firebase: FirebaseRepository, database: DatabaseRepository, preferences: PreferencesRepository) {
        self.firebase = firebase
        self.database = database
        self.preferences = preferences
        let war = preferences.currentWar
        database.team(id: war?.teamHost ?? "")
            .do(onNext: {
                self.team1 = $0
                self.teamSelected = $0
            })
            .subscribe()
            .disposed(by: disposeBag)
        database.team(id: war?.teamOpponent ?? "")
            .do(onNext: {
                self.team2 = $0
            })
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    
    func onSelectTeam(team: String?) {
        switch (true) {
        case team1?.team_name == team: teamSelected = team1
        default: teamSelected = team2
        }
      }

      func onAmount(amount: String) {
          self.amount = Int(amount)
      }

    func onPenaltyAdded(onFinish: @escaping () -> Void) {
          guard let team = teamSelected else { return }
          guard let amount = amount else { return }
          var penalties = preferences.currentWar?.penalties ?? []
          penalties.append(MKPenalty(teamId: team.id, teamTag: team.team_tag ?? "", amount: amount))
          preferences.currentWar?.penalties = penalties
          firebase.writeCurrentWar(war: FBWar(war: preferences.currentWar!))
          onFinish()
                 
      }


}
