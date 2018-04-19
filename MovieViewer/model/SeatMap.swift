//
//  SeatMap.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import Foundation
import Gloss

struct SeatMap: JSONDecodable {
    let seats: [[String]]?
    let availableSeats: AvailableSeats?
    
    init?(json: JSON) {
        self.seats = "seatmap" <~~ json
        self.availableSeats = "available" <~~ json
    }
}

struct AvailableSeats: Glossy {
    
    let list: [String]?
    let count: Int?
    
    func toJSON() -> JSON? {
        return jsonify([
            "seats" ~~> self.list,
            "seat_count" ~~> self.count
            ])
    }
    
    init?(json: JSON) {
        self.list = "seats" <~~ json
        self.count = "seat_count" <~~ json
    }
}


