//
//  Server+Database.swift
//  FD_iOS_takehome
//
//  Created by Shiv Kalola on 8/12/19.
//  Copyright © 2019 FanDuel. All rights reserved.
//

import Firebase

protocol FirebaseConvertible {
    var json: [String: Any] { get }
    
    init(dictionary: [String: Any])
}

extension Server {
    private static var rootRef: DatabaseReference {
        return Database.database().reference()
    }
    
    private static var game_statesRef: DatabaseReference {
        return Server.rootRef.child("game_states")
    }
    
    private static var gamesRef: DatabaseReference {
        return Server.rootRef.child("games")
    }
    
    private static var player_statsRef: DatabaseReference {
        return Server.rootRef.child("player_stats")
    }
    
    private static var playersRef: DatabaseReference {
        return Server.rootRef.child("players")
    }
    
    private static var teamsRef: DatabaseReference {
        return Server.rootRef.child("teams")
    }
    
}
