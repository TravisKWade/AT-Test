//
//  ViewController.swift
//  AllTrails Test
//
//  Created by Travis Wade on 4/2/21.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, FilterDelegate, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet var filterButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    var businesses: [Business] = []
    var mapBusinesses: [MapBusiness] = []
    var favorites: [NSManagedObject] = []
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        if location != nil {
            centerToLocation(location!)
        }

        filterButton.layer.cornerRadius = 5
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor.lightGray.cgColor
        
        searchTextField.layer.cornerRadius = 5
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.delegate = self
        
        view.backgroundColor = .gray
        convertToMapView()
        setupMapView()
    }

    // MARK: - button handler
    
    @IBAction func listButtonPressed(sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func filterButtonPressed(sender: UIButton) {
        performSegue(withIdentifier: "FilterSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let modal = segue.destination as! FilterViewController
        modal.delegate = self
    }
    
    // MARK: filter delegate
    
    func didSortHighToLow() {
        businesses = businesses.sorted(by: { $0.rating ?? 0 > $1.rating ?? 0 })
    }
    
    func didSortLowToHigh() {
        businesses = businesses.sorted(by: { $0.rating ?? 0 < $1.rating ?? 0 })
    }
    
    // MARK: - Textfield delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        businesses.removeAll()
        searchTextField.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        
        APIService.searchPlaces(searchString: textField.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) { (businesses) in
            self.businesses = businesses
            self.convertToMapView()
            
            DispatchQueue.main.async {
                self.setupMapView()
            }
        }
        
        return true
    }
    
    // MARK: - Map View
    
    func centerToLocation(_ location: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 5000) {
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapBusiness else {
            return nil
        }

        let identifier = "pin"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }

        return view
    }

    func convertToMapView() {
        for biz in businesses {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(biz.geometry.location.lat), longitude: CLLocationDegrees(biz.geometry.location.lng))
            mapBusinesses.append(MapBusiness(name: biz.name,
                                             placeID: biz.place_id,
                                             rating: biz.rating,
                                             totalRatings: biz.user_ratings_total,
                                             priceLevel: biz.price_level,
                                             coordinate: location))
        }
        
        if location != nil {
            centerToLocation(location!)
        } else {
            centerToLocation(mapBusinesses[0].coordinate)
        }
    }
    
    func setupMapView() {
        for biz in mapBusinesses {
            mapView.addAnnotation(biz)
        }
    }
}


