//
//  Players.swift
//  FD_iOS_takehome
//
//  Created by Shiv Kalola on 8/12/19.
//  Copyright © 2019 FanDuel. All rights reserved.
//

import Foundation
import UIKit

struct Players {
    var id: Int
    var name: String
    var team_id: Int
    
    init(id: Int, name: String, team_id: Int) {
        self.id = id
        self.name = name
        self.team_id = team_id
    }
}

// MARK: - FirebaseConvertible
extension Players: FirebaseConvertible {
    var json: [String: Any] {
        return [
            "id": id,
            "name": name,
            "team_id": team_id,
        ]
    }
    
    init(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int else { fatalError() }
        self.id = id
        guard let name = dictionary["name"] as? String else { fatalError() }
        self.name = name
        guard let team_id = dictionary["team_id"] as? Int else { fatalError() }
        self.team_id = team_id
        
    }
}

