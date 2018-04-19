//
//  Movie.swift
//  MovieViewer
//
//  Created by Kevin Maloles on 4/18/18.
//  Copyright © 2018 Kevin Maloles. All rights reserved.
//

import Foundation
import Gloss

struct Movie: JSONDecodable {
    let id: String?
    let advisoryRating: String?
    let canonical_title: String?
    let cast: [String]?
    let genre: String?
    let hasSchedules: Int?
    let isInactive: Int?
    let isShowing: Int?
    let linkName: String?
    let posterImage: String?
    let posterImageLandscape: String?
    let ratings: [String]?
    let releaseDate: String?
    let runtimeMins: String?
    let synopsis: String?
    let trailer: String?
    let averageRating: String?
    let totalReviews: String?
    let variants: [String]?
    let theater: String?
    let order: Int?
    let isFeatured: Int?
    let watchList: Bool?
    let yourRating: Int?
    
    init?(json: JSON) {
        self.id = "movie_id" <~~ json
        self.advisoryRating = "advisory_rating" <~~ json
        self.canonical_title = "canonical_title" <~~ json
        self.cast = "cast" <~~ json
        self.genre = "genre" <~~ json
        self.hasSchedules = "has_schedules" <~~ json
        self.isInactive = "is_inactive" <~~ json
        self.isShowing = "is_showing" <~~ json
        self.linkName = "link_name" <~~ json
        self.posterImage = "poster" <~~ json
        self.posterImageLandscape = "poster_landscape" <~~ json
        self.ratings = "ratings" <~~ json
        self.releaseDate = "release_date" <~~ json
        self.runtimeMins = "runtime_mins" <~~ json
        self.synopsis = "synopsis" <~~ json
        self.trailer = "trailer" <~~ json
        self.averageRating = "average_rating" <~~ json
        self.totalReviews = "total_reviews" <~~ json
        self.variants = "variants" <~~ json
        self.theater = "theater" <~~ json
        self.order = "order" <~~ json
        self.isFeatured = "is_featured" <~~ json
        self.yourRating = "your_rating" <~~ json
        self.watchList = "watch_list" <~~ json
    }
}

