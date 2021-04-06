//
//  PlacesViewController.swift
//  AllTrails Test
//
//  Created by Travis Wade on 4/3/21.
//

import UIKit
import CoreLocation
import CoreData

class PlacesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, FavoriteDelegate, UITextFieldDelegate, FilterDelegate {
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var errorLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var businesses: [Business] = []
    var favorites: [NSManagedObject] = []
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        registerTableCells()
        getFavorites()
        
        filterButton.layer.cornerRadius = 5
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor.lightGray.cgColor
        
        searchTextField.layer.cornerRadius = 5
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.lightGray.cgColor
        searchTextField.delegate = self
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundPressed(_:))))
    }
    
    // MARK: - location
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            tableView.isHidden = false
            errorLabel.text = "There were no results returned. Please try your search again."
            errorLabel.isHidden = true
        } else {
            tableView.isHidden = true
            errorLabel.text = "This is your guy's idea, you should at least turn on location services."
            errorLabel.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        APIService.getPlaces(location: location) { (businesses) in
            self.businesses = businesses
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - button handler
    
    @IBAction func mapButtonPressed(sender: UIButton) {
        performSegue(withIdentifier: "MapSegue", sender: nil)
    }
    
    @IBAction func filterButtonPressed(sender: UIButton) {
        performSegue(withIdentifier: "FilterSegue", sender: nil)
    }
    
    // MARK: - table view methods
    
    func registerTableCells() {
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business: Business = businesses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        
        cell.containerView.layer.cornerRadius = 5
        cell.containerView.layer.borderWidth = 1
        cell.containerView.layer.borderColor = UIColor.lightGray.cgColor
        cell.delegate = self
        cell.business = business
        
        cell.titleLabel.text = business.name
        cell.detailLabel.text = ""
        
        if let price = business.price_level {
            var levelText = ""
            for _ in 0..<(price-1) {
                levelText.append("$")
            }
            
            cell.detailLabel.text = levelText
        }
        
        cell.ratingLabel.text = ""
        
        if let rating = business.rating {
            if rating > 4.9 {
                cell.star1Image.tintColor = UIColor.systemYellow
                cell.star2Image.tintColor = UIColor.systemYellow
                cell.star3Image.tintColor = UIColor.systemYellow
                cell.star4Image.tintColor = UIColor.systemYellow
                cell.star5Image.tintColor = UIColor.systemYellow
            } else if rating > 3.9 && rating < 5 {
                cell.star1Image.tintColor = UIColor.systemYellow
                cell.star2Image.tintColor = UIColor.systemYellow
                cell.star3Image.tintColor = UIColor.systemYellow
                cell.star4Image.tintColor = UIColor.systemYellow
                cell.star5Image.tintColor = UIColor.systemGray3
            } else if rating > 2.9 && rating < 4 {
                cell.star1Image.tintColor = UIColor.systemYellow
                cell.star2Image.tintColor = UIColor.systemYellow
                cell.star3Image.tintColor = UIColor.systemYellow
                cell.star4Image.tintColor = UIColor.systemGray3
                cell.star5Image.tintColor = UIColor.systemGray3
            } else if rating > 1.9 && rating < 3 {
                cell.star1Image.tintColor = UIColor.systemYellow
                cell.star2Image.tintColor = UIColor.systemYellow
                cell.star3Image.tintColor = UIColor.systemGray3
                cell.star4Image.tintColor = UIColor.systemGray3
                cell.star5Image.tintColor = UIColor.systemGray3
            } else if rating > 0.9 && rating < 2 {
                cell.star1Image.tintColor = UIColor.systemYellow
                cell.star2Image.tintColor = UIColor.systemGray3
                cell.star3Image.tintColor = UIColor.systemGray3
                cell.star4Image.tintColor = UIColor.systemGray3
                cell.star5Image.tintColor = UIColor.systemGray3
            } else {
                cell.star1Image.tintColor = UIColor.systemGray3
                cell.star2Image.tintColor = UIColor.systemGray3
                cell.star3Image.tintColor = UIColor.systemGray3
                cell.star4Image.tintColor = UIColor.systemGray3
                cell.star5Image.tintColor = UIColor.systemGray3
            }
        } else {
            cell.star1Image.tintColor = UIColor.white
            cell.star2Image.tintColor = UIColor.white
            cell.star3Image.tintColor = UIColor.white
            cell.star4Image.tintColor = UIColor.white
            cell.star5Image.tintColor = UIColor.white
        }
        
        if let totalRating = business.user_ratings_total {
            cell.ratingLabel.text = "(\(String(totalRating)))"
        }
        
        if checkFavorite(placeID: business.place_id) {
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.favoriteButton.tintColor = UIColor.systemGreen
        } else {
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.favoriteButton.tintColor = UIColor.systemGray3
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // MARK: - favorite delegate
    
    func favoritePressed(placeID: String) {
        for fav in favorites {
            let id = fav.value(forKeyPath: "placeID") as? String
            
            if id == placeID {
                deleteFavorite(place: fav)
                return
            }
        }
        
        saveNewFavorite(placeID: placeID)
    }
    
    // MARK: - Core Data
    
    func getFavorites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Place")

        do {
            favorites = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkFavorite(placeID: String) -> Bool {
        for fav in favorites {
            let id = fav.value(forKeyPath: "placeID") as? String
            
            if id == placeID {
                return true
            }
        }
        
        return false
    }
    
    func saveNewFavorite(placeID: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Place", in: context)!
        let place = NSManagedObject(entity: entity, insertInto: context)

        place.setValue(placeID, forKeyPath: "placeID")

        do {
            try context.save()
            favorites.append(place)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteFavorite(place: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        context.delete(place)
    }

    // MARK: - Textfield delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        errorLabel.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        businesses.removeAll()
        tableView.reloadData()
        searchTextField.resignFirstResponder()
        
        APIService.searchPlaces(searchString: textField.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) { (businesses) in
            self.businesses = businesses
            
            DispatchQueue.main.async {
                if businesses.count == 0 {
                    self.errorLabel.isHidden = false
                }
            
                self.tableView.reloadData()
            }
        }
        
        return true
    }
    
    @objc func backgroundPressed(_ sender: UITapGestureRecognizer? = nil) {
        searchTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterSegue" {
            let modal = segue.destination as! FilterViewController
            modal.delegate = self
        } else {
            let map = segue.destination as! MapViewController
            map.businesses = businesses
            map.location = location
        }
    }
    
    // MARK: filter delegate
    
    func didSortHighToLow() {
        businesses = businesses.sorted(by: { $0.rating ?? 0 > $1.rating ?? 0 })
        tableView.reloadData()
    }
    
    func didSortLowToHigh() {
        businesses = businesses.sorted(by: { $0.rating ?? 0 < $1.rating ?? 0 })
        tableView.reloadData()
    }
}
