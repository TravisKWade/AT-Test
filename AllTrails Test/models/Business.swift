//
//  Business.swift
//  AllTrails Test
//
//  Created by Travis Wade on 4/4/21.
//

import MapKit

struct Business: Codable {
    var name: String
    var place_id: String
    var rating: Float?
    var user_ratings_total: Int?
    var price_level: Int?
    var geometry: Geometry
    var vicinity: String?
}

