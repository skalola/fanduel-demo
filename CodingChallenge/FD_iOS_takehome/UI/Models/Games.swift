//
//  Games.swift
//  FD_iOS_takehome
//
//  Created by Shiv Kalola on 8/12/19.
//  Copyright © 2019 FanDuel. All rights reserved.
//

import Foundation
import UIKit

struct Games {
    var away_team_id: Int
    var date: String
    var home_team_id: Int
    var id: Int
    
    init(away_team_id: Int, date: String, home_team_id: Int, id: Int) {
        self.away_team_id = away_team_id
        self.date = date
        self.home_team_id = home_team_id
        self.id = id
    }
}

// MARK: - FirebaseConvertible
extension Games: FirebaseConvertible {
    var json: [String: Any] {
        return [
            "away_team_id": away_team_id,
            "date": date,
            "home_team_id": home_team_id,
            "id": id
        ]
    }
    
    init(dictionary: [String: Any]) {
        guard let away_team_id = dictionary["away_team_id"] as? Int else { fatalError() }
        self.away_team_id = away_team_id
        guard let date = dictionary["date"] as? String else { fatalError() }
        self.date = date
        guard let home_team_id = dictionary["home_team_id"] as? Int else { fatalError() }
        self.home_team_id = home_team_id
        guard let id = dictionary["id"] as? Int else { fatalError() }
        self.id = id
    }
}

