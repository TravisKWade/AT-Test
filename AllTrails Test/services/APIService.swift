//
//  APIService.swift
//  AllTrails Test
//
//  Created by Travis Wade on 4/3/21.
//

import UIKit
import CoreLocation

class APIService {
    
    static let shared = APIService()
    
    private init(){}
    
    class func getPlaces(location: CLLocationCoordinate2D, completion: @escaping ([Business]) -> Void) {
        
        let url = URL(string:  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDIKzjfQQCahwJ9yEr8gBU9TqJ3MvbPXyY&type=restaurant&radius=5000&location=\(location.latitude),\(location.longitude)")
        let request = URLRequest(url: url!)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                
                do {
                    let businesses = try decoder.decode(Results.self, from: data!)
                    completion(businesses.results)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        dataTask.resume()
        
    }
    
    class func searchPlaces(searchString: String, completion: @escaping ([Business]) -> Void) {
        let url = URL(string:  "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=AIzaSyDIKzjfQQCahwJ9yEr8gBU9TqJ3MvbPXyY&input=\(searchString)&inputtype=textquery&fields=geometry,place_id,name,rating,user_ratings_total,price_level&type=restaurant")
        let request = URLRequest(url: url!)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                
                do {
                    let businesses = try decoder.decode(Candidates.self, from: data!)
                    completion(businesses.candidates)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        dataTask.resume()
    }
}
