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
    
    func setupCell(business: Business) {
        self.business = business
        
        containerView.layer.cornerRadius = 5
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        
        titleLabel.text = business.name
        detailLabel.text = ""
        
        if let price = business.price_level {
            var levelText = ""
            for _ in 0..<(price-1) {
                levelText.append("$")
            }
            
            detailLabel.text = levelText
        }
        
        ratingLabel.text = ""
        
        if let rating = business.rating {
            if rating > 4.9 {
                star1Image.tintColor = UIColor.systemYellow
                star2Image.tintColor = UIColor.systemYellow
                star3Image.tintColor = UIColor.systemYellow
                star4Image.tintColor = UIColor.systemYellow
                star5Image.tintColor = UIColor.systemYellow
            } else if rating > 3.9 && rating < 5 {
                star1Image.tintColor = UIColor.systemYellow
                star2Image.tintColor = UIColor.systemYellow
                star3Image.tintColor = UIColor.systemYellow
                star4Image.tintColor = UIColor.systemYellow
                star5Image.tintColor = UIColor.systemGray3
            } else if rating > 2.9 && rating < 4 {
                star1Image.tintColor = UIColor.systemYellow
                star2Image.tintColor = UIColor.systemYellow
                star3Image.tintColor = UIColor.systemYellow
                star4Image.tintColor = UIColor.systemGray3
                star5Image.tintColor = UIColor.systemGray3
            } else if rating > 1.9 && rating < 3 {
                star1Image.tintColor = UIColor.systemYellow
                star2Image.tintColor = UIColor.systemYellow
                star3Image.tintColor = UIColor.systemGray3
                star4Image.tintColor = UIColor.systemGray3
                star5Image.tintColor = UIColor.systemGray3
            } else if rating > 0.9 && rating < 2 {
                star1Image.tintColor = UIColor.systemYellow
                star2Image.tintColor = UIColor.systemGray3
                star3Image.tintColor = UIColor.systemGray3
                star4Image.tintColor = UIColor.systemGray3
                star5Image.tintColor = UIColor.systemGray3
            } else {
                star1Image.tintColor = UIColor.systemGray3
                star2Image.tintColor = UIColor.systemGray3
                star3Image.tintColor = UIColor.systemGray3
                star4Image.tintColor = UIColor.systemGray3
                star5Image.tintColor = UIColor.systemGray3
            }
        } else {
            star1Image.tintColor = UIColor.white
            star2Image.tintColor = UIColor.white
            star3Image.tintColor = UIColor.white
            star4Image.tintColor = UIColor.white
            star5Image.tintColor = UIColor.white
        }
        
        if let totalRating = business.user_ratings_total {
            ratingLabel.text = "(\(String(totalRating)))"
        }
    }
    
    func setFavorite(isFavorite: Bool) {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = UIColor.systemGreen
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = UIColor.systemGray3
        }
    }
    
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
