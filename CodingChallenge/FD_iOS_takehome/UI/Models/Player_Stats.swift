//
//  PlayerStats.swift
//  FD_iOS_takehome
//
//  Created by Shiv Kalola on 8/12/19.
//  Copyright © 2019 FanDuel. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct Player_Stats {
    var assists: String
    var game_id: String
    var id: String
    var nerd: String
    var player_id: String
    var points: String
    var rebounds: String
    var team_id: String
    
    init(assists: String, game_id: String, id: String, nerd: String, player_id: String, points: String, rebounds: String, team_id: String) {
        self.assists = assists
        self.game_id = game_id
        self.id = id
        self.nerd = nerd
        self.player_id = player_id
        self.points = points
        self.rebounds = rebounds
        self.team_id = team_id
    }
}

// MARK: - FirebaseConvertible
extension Player_Stats: FirebaseConvertible {
    var json: [String: Any] {
        return [
            "assists": assists,
            "game_id": game_id,
            "id": id,
            "nerd": nerd,
            "player_id": player_id,
            "points": points,
            "rebounds": rebounds,
            "team_id": team_id
        ]
    }

    init(dictionary: [String: Any]) {
        guard let assists = dictionary["assists"] as? String else { fatalError() }
        self.assists = assists
        guard let game_id = dictionary["game_id"] as? String else { fatalError() }
        self.game_id = game_id
        guard let id = dictionary["id"] as? String else { fatalError() }
        self.id = id
        guard let nerd = dictionary["nerd"] as? String else { fatalError() }
        self.nerd = nerd
        guard let player_id = dictionary["player_id"] as? String else { fatalError() }
        self.player_id = player_id
        guard let points = dictionary["points"] as? String else { fatalError() }
        self.points = points
        guard let rebounds = dictionary["rebounds"] as? String else { fatalError() }
        self.rebounds = rebounds
        guard let team_id = dictionary["team_id"] as? String else { fatalError() }
        self.team_id = team_id
    }
}


