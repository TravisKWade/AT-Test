//
//  PlaceTableCell.swift
//  AllTrails Test
//
//  Created by Travis Wade on 4/4/21.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var lunchImage: UIImageView!
    @IBOutlet var star1Image: UIImageView!
    @IBOutlet var star2Image: UIImageView!
    @IBOutlet var star3Image: UIImageView!
    @IBOutlet var star4Image: UIImageView!
    @IBOutlet var star5Image: UIImageView!
    
    var delegate: FavoriteDelegate?
    var business: Business?
    
    @IBAction func favoriteButtonPressed(sender: UIButton) {
        if favoriteButton.tintColor == UIColor.systemGreen {
            self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.favoriteButton.tintColor = UIColor.systemGray3
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.favoriteButton.tintColor = UIColor.systemGreen
        }
        
        delegate?.favoritePressed(placeID: business!.place_id)
    }
}
