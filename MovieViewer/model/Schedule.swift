//
//  Schedule.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import Foundation
import Gloss

struct MovieSchedule: JSONDecodable {
    let dates: [MovieDate]?
    let cinemas: [Cinema]?
    let schedules: [Schedule]?
    
    init?(json: JSON) {
        self.dates = "dates" <~~ json
        self.cinemas = "cinemas" <~~ json
        self.schedules = "times" <~~ json
    }
}

struct MovieDate: Glossy {
    
    let id: String?
    let label: String?
    let date: String?
    
    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "label" ~~> self.label,
            "date"  ~~> self.date,
            ])
    }
    
    init?(json: JSON) {
        self.id = "id" <~~ json
        self.label = "label" <~~ json
        self.date = "date" <~~ json
    }
}

struct CinemaNumber: Glossy {
    
    let id: String?
    let cinemaId: String?
    let label: String?
    
    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "cinema_id" ~~> self.cinemaId,
            "label"  ~~> self.label,
            ])
    }
    
    init?(json: JSON) {
        self.id = "id" <~~ json
        self.cinemaId = "cinema_id" <~~ json
        self.label = "label" <~~ json
    }
}

struct Cinema: Glossy {
    
    let parent: String?
    let cinemas: [CinemaNumber]?
    
    func toJSON() -> JSON? {
        return jsonify([
            "parent" ~~> self.parent,
            "cinemas" ~~> self.cinemas
            ])
    }
    
    init?(json: JSON) {
        self.parent = "parent" <~~ json
        self.cinemas = "cinemas" <~~ json
    }
}

struct TimeSchedule: Glossy {
    
    let id: String?
    let label: String?
    let scheduleId: String?
    let popcornPrice: String?
    let popcornLabel: String?
    let seatingType: String?
    let price: String?
    let variant: String?
    
    func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "label" ~~> self.label,
            "schedule_id" ~~> self.scheduleId,
            "popcorn_label" ~~> self.popcornLabel,
            "popcorn_price" ~~> self.popcornPrice,
            "seating_type" ~~> self.seatingType,
            "price" ~~> self.price,
            "variant" ~~> self.variant
            ])
    }
    
    init?(json: JSON) {
        self.id = "id" <~~ json
        self.label = "label" <~~ json
        self.scheduleId = "schedule_id" <~~ json
        self.popcornLabel = "popcorn_label" <~~ json
        self.popcornPrice = "popcorn_price" <~~ json
        self.seatingType = "seating_type" <~~ json
        self.price = "price" <~~ json
        self.variant = "variant" <~~ json
    }
}

struct Schedule: Glossy {
    
    let parent: String?
    let times: [TimeSchedule]?
    
    func toJSON() -> JSON? {
        return jsonify([
            "parent" ~~> self.parent,
            "times" ~~> self.times
            ])
    }
    
    init?(json: JSON) {
        self.parent = "parent" <~~ json
        self.times = "times" <~~ json
    }
}









