//
//  FilterViewController.swift
//  AllTrails Test
//
//  Created by Travis Wade on 4/5/21.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet var lowToHighButton: UIButton!
    @IBOutlet var highToLowButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var delegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lowToHighButton.layer.cornerRadius = 5
        lowToHighButton.layer.borderWidth = 1
        lowToHighButton.layer.borderColor = UIColor.lightGray.cgColor
        
        highToLowButton.layer.cornerRadius = 5
        highToLowButton.layer.borderWidth = 1
        highToLowButton.layer.borderColor = UIColor.lightGray.cgColor
        
        cancelButton.layer.cornerRadius = 5
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.lightGray.cgColor]
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    // MARK: - button handler
    
    @IBAction func lowButtonPressed(sender: UIButton) {
        delegate!.didSortLowToHigh()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func highButtonPressed(sender: UIButton) {
        delegate!.didSortHighToLow()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
