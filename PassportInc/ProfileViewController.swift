//
//  ProfileViewController.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    // MARK: Custom Properties
    var profileToView: Profile!
    
    // MARK: IBOutlet Properties
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var hobbiesTextView: UITextView!
    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        self.navigationItem.title = profileToView.name
        self.view.backgroundColor = profileToView.gender == "M" ? UIColor.blue : UIColor.green
        self.genderLabel.text = profileToView.gender
        self.ageLabel.text = "\(profileToView.age)"
    }
}
