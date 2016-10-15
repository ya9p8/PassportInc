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
    
    // MARK: Custom Methods
    func updateUI() {
        nameLabel.text = "Name: \(profile.name)"
        ageLabel.text = "Age: \(profile.age)"
        genderLabel.text = "Gender: \(profile.gender)"
        profileImageView.image = profile.image
    }
}
