//
//  MapBusiness.swift
//  AllTrails Test
//
//  Created by Travis Wade on 4/5/21.
//

import UIKit
import MapKit

class MapBusiness: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var place_id: String
    var rating: Float?
    var user_ratings_total: Int?
    var price_level: Int?
    
    init(name: String, placeID: String, rating: Float?, totalRatings: Int?, priceLevel: Int?, coordinate: CLLocationCoordinate2D) {
        
        self.title = name
        self.place_id = placeID
        self.rating = rating ?? 0
        self.user_ratings_total = totalRatings ?? 0
        self.coordinate = coordinate
        self.price_level = price_level ?? 0
        
        super.init()
    }
}
