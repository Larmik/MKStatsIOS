//
//  PreferencesRepository.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation


protocol PreferencesRepositoryProtocol {
    var currentWar: MKWar? { get set }
    var currentWarTrack: MKWarTrack? { get set }
    var currentTheme: Int { get set }
    var authEmail: String? { get set }
    var authPassword: String? { get set }
    var firstLaunch: Bool { get set }
    var indivEnabled: Bool { get set }
    var fcmToken: String? { get set }
    var mkcPlayer: MKCFullPlayer? { get set }
    var mkcTeam: MKCFullTeam? { get set }
    var rosterList: [MKCLightPlayer]? { get set }
    var role: Int { get set }
}

class PreferencesRepository: PreferencesRepositoryProtocol {
    
    var rosterList: [MKCLightPlayer]?
        {
           get {
               if let data = userDefault.object(forKey: "rosterList") as? Data,
                  let player = try? JSONDecoder().decode([MKCLightPlayer].self, from: data) {
                    return player
               }
               return nil
           }
           set {
               if let encoded = try? JSONEncoder().encode(newValue) {
                   userDefault.set(encoded, forKey: "rosterList")
               }
           }
       }
    
    
    private let userDefault = UserDefaults.standard

     
    init() { }
    
    var currentWar: MKWar? {
        get {
            if let data = userDefault.object(forKey: "currentWar") as? Data,
               let player = try? JSONDecoder().decode(MKWar.self, from: data) {
                 return player
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefault.set(encoded, forKey: "currentWar")
            }
        }
    }
       
    
    var currentWarTrack: MKWarTrack? {
        get {
            if let data = userDefault.object(forKey: "currentWarTrack") as? Data,
               let player = try? JSONDecoder().decode(MKWarTrack.self, from: data) {
                 return player
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefault.set(encoded, forKey: "currentWarTrack")
            }
        }
    }
    
    var currentTheme: Int {
        get {
            return userDefault.object(forKey: "currentTheme") as! Int
        }
        set {
            userDefault.set(newValue, forKey: "currentTheme")
        }
    }
    
    var authEmail: String? {
        get {
            return userDefault.object(forKey: "authEmail") as? String
        }
        set {
            userDefault.set(newValue, forKey: "authEmail")
        }
    }
    
    var authPassword: String? {
        get {
            return userDefault.object(forKey: "authPassword") as? String
        }
        set {
            userDefault.set(newValue, forKey: "authPassword")
        }
    }
    
    var firstLaunch: Bool {
        get {
            return userDefault.object(forKey: "firstLaunch") as? Bool ?? true
        }
        set {
            userDefault.set(newValue, forKey: "firstLaunch")
        }
    }
    
    var indivEnabled: Bool {
        get {
            return userDefault.object(forKey: "indivEnabled") as! Bool
        }
        set {
            userDefault.set(newValue, forKey: "indivEnabled")
        }
    }
    
    var fcmToken: String? {
        get {
            return userDefault.object(forKey: "fcmToken") as? String
        }
        set {
            userDefault.set(newValue, forKey: "fcmToken")
        }
    }
    
    var mkcPlayer: MKCFullPlayer? {
        get {
            if let data = userDefault.object(forKey: "mkcPlayer") as? Data,
               let player = try? JSONDecoder().decode(MKCFullPlayer.self, from: data) {
                 return player
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefault.set(encoded, forKey: "mkcPlayer")
            }
        }
    }
    
    var mkcTeam: MKCFullTeam? {
        get {
            if let data = userDefault.object(forKey: "mkcTeam") as? Data,
               let player = try? JSONDecoder().decode(MKCFullTeam.self, from: data) {
                 return player
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefault.set(encoded, forKey: "mkcTeam")
            }
        }
    }
    
    var role: Int {
        get {
            return userDefault.object(forKey: "role") as? Int ?? 0
        }
        set {
            userDefault.set(newValue, forKey: "role")
        }
    }
    
    
    
}

