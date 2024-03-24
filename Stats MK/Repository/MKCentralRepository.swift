//
//  MKCentralRepository.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation
import RxSwift


protocol MKCentralRepositoryProtocol {
    func teams() -> Observable<[MKCTeam]?>
    func historicalTeams() -> Observable<[MKCTeam]?>
    func team(id: String) -> Observable<MKCFullTeam?>
    func player(id: String) -> Observable<MKCFullPlayer?>
    func searchPlayers(search: String) -> Observable<[MKCPlayer]?>
}

class MKCentralRepository: MKCentralRepositoryProtocol {
    
    let decoder = JSONDecoder()
    let baseUrl = "https://www.mariokartcentral.com/mkc/api/registry"
    
    func historicalTeams() -> RxSwift.Observable<[MKCTeam]?> {
        return Observable.create {[weak self] observer in
            
            guard let self = self else { return Disposables.create() }
            let urlBuilder = URLComponents(string: baseUrl + "/teams/category/historical" )
            let urlConfiguration = URLSessionConfiguration.default
            guard let url = urlBuilder?.url else {
                observer.onNext([])
                observer.onCompleted()
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession(configuration: urlConfiguration).dataTask(with: request) { (data, response, error) in
                guard let teamData = data,
                      let decodedData = try? self.decoder.decode(MKCTeamResponse.self, from: teamData) else {
                    observer.onNext([])
                    observer.onCompleted()
                    return
                }
                observer.onNext(decodedData.data)
                observer.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
    
    func team(id: String) -> RxSwift.Observable<MKCFullTeam?> {
        return Observable.create {[weak self] observer in
            
            guard let self = self else { return Disposables.create() }
            let urlBuilder = URLComponents(string: baseUrl + "/teams/" + id )
            let urlConfiguration = URLSessionConfiguration.default
            guard let url = urlBuilder?.url else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession(configuration: urlConfiguration).dataTask(with: request) { (data, response, error) in
                guard let teamData = data,
                      var decodedData = try? self.decoder.decode(MKCFullTeam.self, from: teamData) else {
                    observer.onCompleted()
                    return
                }
                
                let teamDic = self.convertToDictionary(text: String(data: teamData, encoding: .utf8)!)
                let rosterDic = teamDic?["rosters"] as! NSDictionary
                let rosterList = rosterDic["150cc"] as! NSDictionary
                let membersList = rosterList["members"] as! [NSDictionary]
                var playerList = [MKCLightPlayer]()
                for player in membersList {
                    let lightPlayer = MKCLightPlayer(
                        mkcId: player.object(forKey: "player_id") as! Int,
                        name: player.object(forKey: "display_name") as! String,
                        fc: player.object(forKey: "custom_field") as! String,
                        status: player.object(forKey: "player_status") as! String,
                        registerDate: player.object(forKey: "registered_since") as! String,
                        country: player.object(forKey: "country_code") as! String,
                        isLeader: player.object(forKey: "team_leader") as! Int,
                        role: 0,
                        currentWar: "-1",
                        picture: "",
                        isAlly: 0
                    )
                    playerList.append(lightPlayer)
                }
                decodedData.rosters = playerList
                observer.onNext(decodedData)
                observer.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
    
    func player(id: String) -> RxSwift.Observable<MKCFullPlayer?> {
        return Observable.create {[weak self] observer in
            
            guard let self = self else { return Disposables.create() }
            let urlBuilder = URLComponents(string: baseUrl + "/players/" + id )
            let urlConfiguration = URLSessionConfiguration.default
            guard let url = urlBuilder?.url else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession(configuration: urlConfiguration).dataTask(with: request) { (data, response, error) in
                guard let teamData = data,
                      let decodedData = try? self.decoder.decode(MKCFullPlayer.self, from: teamData) else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                observer.onNext(decodedData)
                observer.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
    
    func searchPlayers(search: String) -> RxSwift.Observable<[MKCPlayer]?> {
        return Observable.create {[weak self] observer in
            
            guard let self = self else { return Disposables.create() }
            let urlBuilder = URLComponents(string: baseUrl + "/players/category/150cc?search=" + search )
            let urlConfiguration = URLSessionConfiguration.default
            guard let url = urlBuilder?.url else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession(configuration: urlConfiguration).dataTask(with: request) { (data, response, error) in
                guard let teamData = data,
                      let decodedData = try? self.decoder.decode([MKCPlayer].self, from: teamData) else {
                    observer.onCompleted()
                    return
                }
                observer.onNext(decodedData)
                observer.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
    
    func teams() -> Observable<[MKCTeam]?> {
        return Observable.create {[weak self] observer in
            
            guard let self = self else { return Disposables.create() }
            let urlBuilder = URLComponents(string: baseUrl + "/teams/category/150cc" )
            let urlConfiguration = URLSessionConfiguration.default
            guard let url = urlBuilder?.url else {
                observer.onNext([])
                observer.onCompleted()
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession(configuration: urlConfiguration).dataTask(with: request) { (data, response, error) in
                guard let teamData = data,
                      let decodedData = try? self.decoder.decode(MKCTeamResponse.self, from: teamData) else {
                    observer.onNext([])
                    observer.onCompleted()
                    return 
                }
                observer.onNext(decodedData.data)
                observer.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}


