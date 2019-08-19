//
//  GameStates.swift
//  FD_iOS_takehome
//
//  Created by Shiv Kalola on 8/12/19.
//  Copyright © 2019 FanDuel. All rights reserved.
//

import Foundation
import UIKit

struct Game_States {
    var away_team_score: String
    var broadcast: String
    var game_id: Int
    var game_status: String
    var home_team_score: String
    var id: Int
    var quarter: String
    var time_left_in_quarter: String
    var game_start: String
    
    init(away_team_score: String, broadcast: String, game_id: Int, game_status: String, home_team_score: String, id: Int, quarter: String, time_left_in_quarter: String, game_start: String) {
        self.away_team_score = away_team_score
        self.broadcast = broadcast
        self.game_id = game_id
        self.game_status = game_status
        self.home_team_score = home_team_score
        self.id = id
        self.quarter = quarter
        self.time_left_in_quarter = time_left_in_quarter
        self.game_start = game_start
    }
}

// MARK: - FirebaseConvertible
extension Game_States: FirebaseConvertible {
    var json: [String: Any] {
        return [
            "away_team_score": away_team_score,
            "broadcast": broadcast,
            "game_id": game_id,
            "game_status": game_status,
            "home_team_score": home_team_score,
            "id": id,
            "quarter": quarter,
            "time_left_in_quarter": time_left_in_quarter,
            "game_start": game_start
        ]
    }
    
    init(dictionary: [String: Any]) {
        guard let away_team_score = dictionary["away_team_score"] as? String else { fatalError() }
        self.away_team_score = away_team_score
        guard let broadcast = dictionary["broadcast"] as? String else { fatalError() }
        self.broadcast = broadcast
        guard let game_id = dictionary["game_id"] as? Int else { fatalError() }
        self.game_id = game_id
        guard let game_status = dictionary["game_status"] as? String else { fatalError() }
        self.game_status = game_status
        guard let home_team_score = dictionary["home_team_score"] as? String else { fatalError() }
        self.home_team_score = home_team_score
        guard let id = dictionary["id"] as? Int else { fatalError() }
        self.id = id
        guard let quarter = dictionary["quarter"] as? String else { fatalError() }
        self.quarter = quarter
        guard let time_left_in_quarter = dictionary["time_left_in_quarter"] as? String else { fatalError() }
        self.time_left_in_quarter = time_left_in_quarter
        guard let game_start = dictionary["game_start"] as? String else { fatalError() }
        self.game_start = game_start
    }
}


