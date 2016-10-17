//
//  ProfileTableViewCell.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit


class ProfileTableViewCell: UITableViewCell {
    
    
    // MARK: Custom Properties
    var profile: Profile! {
        didSet { updateUI() }
    }
    
    
    // MARK: IBOutlet Properties
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    // MARK: TableViewCell Construction
    override func awakeFromNib() {
        updateWithImage(image: nil)
    }
    
    override func prepareForReuse() {
        updateWithImage(image: nil)
    }
    
    // MARK: Custom Methods
    func updateUI() {
        nameLabel.text = "Name: \(profile.name)"
        ageLabel.text = "Age: \(profile.age)"
        genderLabel.text = "Gender: \(profile.gender)"
    }
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            profileImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            profileImageView.image = nil
        }
    }
}
