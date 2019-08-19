//
//  Teams.swift
//  FD_iOS_takehome
//
//  Created by Shiv Kalola on 8/12/19.
//  Copyright © 2019 FanDuel. All rights reserved.
//

import Foundation
import UIKit

struct Teams {
    var abbrev: String
    var city: String
    var color: String
    var full_name: String
    var id: Int
    var name: String
    var record: String
    
    init(abbrev: String, city: String, color: String, full_name: String, id: Int, name: String, record: String) {
        self.abbrev = abbrev
        self.city = city
        self.color = color
        self.full_name = full_name
        self.id = id
        self.name = name
        self.record = record
    }
}

// MARK: - FirebaseConvertible
extension Teams: FirebaseConvertible {
    var json: [String: Any] {
        return [
            "abbrev": abbrev,
            "city": city,
            "color": color,
            "full_name": full_name,
            "id": id,
            "name": name,
            "record": record
        ]
    }
    
    init(dictionary: [String: Any]) {
        guard let abbrev = dictionary["abbrev"] as? String else { fatalError() }
        self.abbrev = abbrev
        guard let city = dictionary["city"] as? String else { fatalError() }
        self.city = city
        guard let color = dictionary["color"] as? String else { fatalError() }
        self.color = color
        guard let full_name = dictionary["full_name"] as? String else { fatalError() }
        self.full_name = full_name
        guard let id = dictionary["id"] as? Int else { fatalError() }
        self.id = id
        guard let name = dictionary["name"] as? String else { fatalError() }
        self.name = name
        guard let record = dictionary["record"] as? String else { fatalError() }
        self.record = record
    }
}

