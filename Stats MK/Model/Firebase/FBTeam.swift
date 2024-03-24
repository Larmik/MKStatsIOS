//
//  Team.swift
//  Stats MK
//
//  Created by Pascal Alberti on 19/01/2024.
//

import Foundation

struct FBTeam: Codable, Identifiable {
    var id = UUID()
    let mid: String
    let name: String?
    let shortName: String?
    
    init(mid: String, name: String?, shortName: String?) {
        self.mid = mid
        self.name = name
        self.shortName = shortName
    }
    
    private enum CodingKeys: String, CodingKey {
       case mid, name, shortName
    }
}
